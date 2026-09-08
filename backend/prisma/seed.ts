import "dotenv/config";

import { PrismaMssql } from "@prisma/adapter-mssql";
import { PrismaClient } from "../src/generated/prisma/client.js";

const adapter = new PrismaMssql({
  server: process.env.DB_SERVER!,
  port: Number(process.env.DB_PORT!),
  user: process.env.DB_USER!,
  password: process.env.DB_PASSWORD!,
  database: process.env.DB_NAME!,
  options: {
    encrypt: true,
    trustServerCertificate: true,
  },
});

const prisma = new PrismaClient({
  adapter,
});

async function main() {
  console.log("🌱 Iniciando seed de Crearte...\n");

  // ============================================================
  // ROLES
  // ============================================================

  console.log("👤 Creando roles...");

  const roles = [
    {
      code: "ADMIN",
      name: "Administrador",
      description: "Administrador general de la plataforma",
    },
    {
      code: "DESIGNER",
      name: "Diseñador",
      description: "Usuario encargado de los servicios de diseño",
    },
    {
      code: "CUSTOMER",
      name: "Cliente",
      description: "Cliente de Crearte",
    },
  ];

  for (const role of roles) {
    await prisma.role.upsert({
      where: {
        code: role.code,
      },
      update: {
        name: role.name,
        description: role.description,
        isActive: true,
      },
      create: {
        code: role.code,
        name: role.name,
        description: role.description,
        isActive: true,
      },
    });
  }

  // ============================================================
  // CATEGORÍAS
  // ============================================================

  console.log("📦 Creando categorías...");

  const categories = [
    {
      code: "AGENDAS",
      name: "Agendas Personalizadas",
      description: "Agendas personalizadas para diferentes ocasiones",
      sortOrder: 1,
    },
    {
      code: "TARJETAS",
      name: "Tarjetas de presentación",
      description: "Tarjetas de presentación personalizadas",
      sortOrder: 2,
    },
    {
      code: "DTF_UV",
      name: "DTF UV Personalizado",
      description: "Productos personalizados mediante impresión DTF UV",
      sortOrder: 3,
    },
    {
      code: "TAZAS",
      name: "Tazas personalizadas",
      description: "Tazas personalizadas con diseños especiales",
      sortOrder: 4,
    },
    {
      code: "VASOS",
      name: "Vasos SnoGlow personalizados",
      description: "Vasos SnoGlow personalizados",
      sortOrder: 5,
    },
  ];

  for (const category of categories) {
    await prisma.category.upsert({
      where: {
        code: category.code,
      },
      update: {
        name: category.name,
        description: category.description,
        sortOrder: category.sortOrder,
        isActive: true,
      },
      create: {
        code: category.code,
        name: category.name,
        description: category.description,
        sortOrder: category.sortOrder,
        isActive: true,
      },
    });
  }

  // ============================================================
  // MÉTODOS DE ENVÍO
  // ============================================================

  console.log("🚚 Creando métodos de envío...");

  const shippingMethods = [
    {
      code: "DELIVERY",
      name: "Entrega a domicilio",
      description: "Entrega del pedido a la dirección indicada por el cliente",
      type: "DELIVERY",
      basePrice: 0,
    },
    {
      code: "PICKUP",
      name: "Retiro",
      description: "Retiro del pedido en un punto de entrega de Crearte",
      type: "PICKUP",
      basePrice: 0,
    },
  ];

  for (const method of shippingMethods) {
    await prisma.shippingMethod.upsert({
      where: {
        code: method.code,
      },
      update: {
        name: method.name,
        description: method.description,
        type: method.type,
        basePrice: method.basePrice,
        isActive: true,
      },
      create: {
        code: method.code,
        name: method.name,
        description: method.description,
        type: method.type,
        basePrice: method.basePrice,
        isActive: true,
      },
    });
  }

  // ============================================================
  // ZONA DE ENVÍO
  // ============================================================

  console.log("🇨🇷 Creando zona de envío...");

  await prisma.shippingZone.upsert({
    where: {
      code: "CR",
    },
    update: {
      name: "Costa Rica",
      description: "Cobertura nacional dentro de Costa Rica",
      isActive: true,
    },
    create: {
      code: "CR",
      name: "Costa Rica",
      description: "Cobertura nacional dentro de Costa Rica",
      isActive: true,
    },
  });

  // ============================================================
  // SERVICIOS DE DISEÑO
  // ============================================================

  console.log("🎨 Creando servicios de diseño...");

  const designServices = [
    {
      code: "LOGO",
      name: "Diseño de logos",
      description: "Diseño de identidad gráfica y logos personalizados",
    },
    {
      code: "MENU_RESTAURANTE",
      name: "Diseño de menús para restaurantes",
      description: "Diseño de menús personalizados para restaurantes",
    },
    {
      code: "TARJETA_DISENO",
      name: "Diseño de tarjetas",
      description: "Diseño personalizado de tarjetas",
    },
  ];

  for (const service of designServices) {
    await prisma.designService.upsert({
      where: {
        code: service.code,
      },
      update: {
        name: service.name,
        description: service.description,
        isActive: true,
      },
      create: {
        code: service.code,
        name: service.name,
        description: service.description,
        basePrice: null,
        requiresQuote: true,
        isActive: true,
      },
    });
  }

  console.log("\n✅ Seed de Crearte completado correctamente.");
}

main()
  .catch((error) => {
    console.error("\n❌ Error ejecutando el seed:");
    console.error(error);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });