import {
  ConflictException,
  Injectable,
  UnauthorizedException,
} from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import * as argon2 from 'argon2';

import { PrismaService } from '../prisma/prisma.service.js';
import { LoginDto } from './dto/login.dto.js';
import { RegisterDto } from './dto/register.dto.js';

@Injectable()
export class AuthService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly jwtService: JwtService,
  ) {}

  /**
   * Registra un nuevo cliente.
   */
  async register(dto: RegisterDto) {
    const email = dto.email.trim().toLowerCase();

    // 1. Verificar si el email ya existe
    const existingUser = await this.prisma.user.findUnique({
      where: {
        email,
      },
    });

    if (existingUser) {
      throw new ConflictException(
        'Ya existe un usuario registrado con este email',
      );
    }

    // 2. Buscar el rol CUSTOMER
    const customerRole = await this.prisma.role.findUnique({
      where: {
        code: 'CUSTOMER',
      },
    });

    if (!customerRole) {
      throw new Error(
        'El rol CUSTOMER no existe. Ejecuta el seed de la base de datos.',
      );
    }

    // 3. Generar hash seguro de la contraseña
    const passwordHash = await argon2.hash(dto.password);

    // 4. Crear User + Customer + UserRole en una transacción
    const user = await this.prisma.$transaction(async (tx) => {
      const newUser = await tx.user.create({
        data: {
          email,
          passwordHash,
          firstName: dto.firstName.trim(),
          lastName: dto.lastName.trim(),
          phone: dto.phone?.trim() || null,
          isActive: true,
        },
      });

      await tx.userRole.create({
        data: {
          userId: newUser.id,
          roleId: customerRole.id,
        },
      });

      await tx.customer.create({
        data: {
          userId: newUser.id,
          firstName: newUser.firstName,
          lastName: newUser.lastName,
          email: newUser.email,
          phone: newUser.phone,
          isActive: true,
        },
      });

      return newUser;
    });

    // 5. Generar JWT
    const accessToken = await this.generateAccessToken(user.id, email);

    return {
      user: {
        id: user.id,
        email: user.email,
        firstName: user.firstName,
        lastName: user.lastName,
      },
      accessToken,
    };
  }

  /**
   * Autentica un usuario.
   */
  async login(dto: LoginDto) {
    const email = dto.email.trim().toLowerCase();

    // 1. Buscar usuario incluyendo sus roles
    const user = await this.prisma.user.findUnique({
      where: {
        email,
      },
      include: {
        userRoles: {
          include: {
            role: true,
          },
        },
      },
    });

    if (!user) {
      throw new UnauthorizedException('Email o contraseña incorrectos');
    }

    // 2. Verificar que el usuario esté activo
    if (!user.isActive) {
      throw new UnauthorizedException('El usuario está inactivo');
    }

    // 3. Verificar contraseña
    const passwordValid = await argon2.verify(
      user.passwordHash,
      dto.password,
    );

    if (!passwordValid) {
      throw new UnauthorizedException('Email o contraseña incorrectos');
    }

    // 4. Actualizar último login
    await this.prisma.user.update({
      where: {
        id: user.id,
      },
      data: {
        lastLoginAt: new Date(),
      },
    });

    // 5. Obtener códigos de roles
    const roles = user.userRoles.map((userRole) => userRole.role.code);

    // 6. Generar JWT
    const accessToken = await this.generateAccessToken(user.id, user.email, roles);

    return {
      user: {
        id: user.id,
        email: user.email,
        firstName: user.firstName,
        lastName: user.lastName,
        roles,
      },
      accessToken,
    };
  }

  /**
   * Genera el JWT utilizado por la aplicación.
   */
  private async generateAccessToken(
    userId: string,
    email: string,
    roles: string[] = ['CUSTOMER'],
  ) {
    return this.jwtService.signAsync({
      sub: userId,
      email,
      roles,
    });
  }
}