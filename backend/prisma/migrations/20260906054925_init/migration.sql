BEGIN TRY

BEGIN TRAN;

-- CreateTable
CREATE TABLE [dbo].[User] (
    [id] UNIQUEIDENTIFIER NOT NULL,
    [email] NVARCHAR(320) NOT NULL,
    [passwordHash] NVARCHAR(255) NOT NULL,
    [firstName] NVARCHAR(100) NOT NULL,
    [lastName] NVARCHAR(100) NOT NULL,
    [phone] NVARCHAR(30),
    [isActive] BIT NOT NULL CONSTRAINT [User_isActive_df] DEFAULT 1,
    [lastLoginAt] DATETIME2,
    [createdAt] DATETIME2 NOT NULL CONSTRAINT [User_createdAt_df] DEFAULT CURRENT_TIMESTAMP,
    [updatedAt] DATETIME2 NOT NULL,
    CONSTRAINT [User_pkey] PRIMARY KEY CLUSTERED ([id]),
    CONSTRAINT [User_email_key] UNIQUE NONCLUSTERED ([email])
);

-- CreateTable
CREATE TABLE [dbo].[Role] (
    [id] UNIQUEIDENTIFIER NOT NULL,
    [code] VARCHAR(50) NOT NULL,
    [name] NVARCHAR(100) NOT NULL,
    [description] NVARCHAR(500),
    [isActive] BIT NOT NULL CONSTRAINT [Role_isActive_df] DEFAULT 1,
    [createdAt] DATETIME2 NOT NULL CONSTRAINT [Role_createdAt_df] DEFAULT CURRENT_TIMESTAMP,
    [updatedAt] DATETIME2 NOT NULL,
    CONSTRAINT [Role_pkey] PRIMARY KEY CLUSTERED ([id]),
    CONSTRAINT [Role_code_key] UNIQUE NONCLUSTERED ([code])
);

-- CreateTable
CREATE TABLE [dbo].[UserRole] (
    [id] UNIQUEIDENTIFIER NOT NULL,
    [userId] UNIQUEIDENTIFIER NOT NULL,
    [roleId] UNIQUEIDENTIFIER NOT NULL,
    [createdAt] DATETIME2 NOT NULL CONSTRAINT [UserRole_createdAt_df] DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT [UserRole_pkey] PRIMARY KEY CLUSTERED ([id]),
    CONSTRAINT [UserRole_userId_roleId_key] UNIQUE NONCLUSTERED ([userId],[roleId])
);

-- CreateTable
CREATE TABLE [dbo].[Customer] (
    [id] UNIQUEIDENTIFIER NOT NULL,
    [userId] UNIQUEIDENTIFIER,
    [firstName] NVARCHAR(100) NOT NULL,
    [lastName] NVARCHAR(100) NOT NULL,
    [email] NVARCHAR(320) NOT NULL,
    [phone] NVARCHAR(30),
    [identificationNumber] NVARCHAR(30),
    [isActive] BIT NOT NULL CONSTRAINT [Customer_isActive_df] DEFAULT 1,
    [createdAt] DATETIME2 NOT NULL CONSTRAINT [Customer_createdAt_df] DEFAULT CURRENT_TIMESTAMP,
    [updatedAt] DATETIME2 NOT NULL,
    CONSTRAINT [Customer_pkey] PRIMARY KEY CLUSTERED ([id]),
    CONSTRAINT [Customer_userId_key] UNIQUE NONCLUSTERED ([userId])
);

-- CreateTable
CREATE TABLE [dbo].[Address] (
    [id] UNIQUEIDENTIFIER NOT NULL,
    [customerId] UNIQUEIDENTIFIER NOT NULL,
    [name] NVARCHAR(100) NOT NULL,
    [recipientName] NVARCHAR(200) NOT NULL,
    [phone] NVARCHAR(30),
    [province] NVARCHAR(100) NOT NULL,
    [canton] NVARCHAR(100) NOT NULL,
    [district] NVARCHAR(100) NOT NULL,
    [addressLine1] NVARCHAR(500) NOT NULL,
    [addressLine2] NVARCHAR(500),
    [reference] NVARCHAR(500),
    [isDefault] BIT NOT NULL CONSTRAINT [Address_isDefault_df] DEFAULT 0,
    [isActive] BIT NOT NULL CONSTRAINT [Address_isActive_df] DEFAULT 1,
    [createdAt] DATETIME2 NOT NULL CONSTRAINT [Address_createdAt_df] DEFAULT CURRENT_TIMESTAMP,
    [updatedAt] DATETIME2 NOT NULL,
    CONSTRAINT [Address_pkey] PRIMARY KEY CLUSTERED ([id])
);

-- CreateTable
CREATE TABLE [dbo].[Category] (
    [id] UNIQUEIDENTIFIER NOT NULL,
    [code] VARCHAR(50) NOT NULL,
    [name] NVARCHAR(150) NOT NULL,
    [description] NVARCHAR(500),
    [sortOrder] INT NOT NULL CONSTRAINT [Category_sortOrder_df] DEFAULT 0,
    [isActive] BIT NOT NULL CONSTRAINT [Category_isActive_df] DEFAULT 1,
    [createdAt] DATETIME2 NOT NULL CONSTRAINT [Category_createdAt_df] DEFAULT CURRENT_TIMESTAMP,
    [updatedAt] DATETIME2 NOT NULL,
    CONSTRAINT [Category_pkey] PRIMARY KEY CLUSTERED ([id]),
    CONSTRAINT [Category_code_key] UNIQUE NONCLUSTERED ([code])
);

-- CreateTable
CREATE TABLE [dbo].[Product] (
    [id] UNIQUEIDENTIFIER NOT NULL,
    [categoryId] UNIQUEIDENTIFIER NOT NULL,
    [sku] VARCHAR(100) NOT NULL,
    [name] NVARCHAR(200) NOT NULL,
    [slug] VARCHAR(250) NOT NULL,
    [description] NVARCHAR(2000),
    [basePrice] DECIMAL(18,2) NOT NULL,
    [isCustomizable] BIT NOT NULL CONSTRAINT [Product_isCustomizable_df] DEFAULT 0,
    [isActive] BIT NOT NULL CONSTRAINT [Product_isActive_df] DEFAULT 1,
    [createdAt] DATETIME2 NOT NULL CONSTRAINT [Product_createdAt_df] DEFAULT CURRENT_TIMESTAMP,
    [updatedAt] DATETIME2 NOT NULL,
    CONSTRAINT [Product_pkey] PRIMARY KEY CLUSTERED ([id]),
    CONSTRAINT [Product_sku_key] UNIQUE NONCLUSTERED ([sku]),
    CONSTRAINT [Product_slug_key] UNIQUE NONCLUSTERED ([slug])
);

-- CreateTable
CREATE TABLE [dbo].[ProductImage] (
    [id] UNIQUEIDENTIFIER NOT NULL,
    [productId] UNIQUEIDENTIFIER NOT NULL,
    [storageKey] NVARCHAR(500) NOT NULL,
    [fileName] NVARCHAR(255) NOT NULL,
    [contentType] VARCHAR(100) NOT NULL,
    [altText] NVARCHAR(255),
    [sortOrder] INT NOT NULL CONSTRAINT [ProductImage_sortOrder_df] DEFAULT 0,
    [isPrimary] BIT NOT NULL CONSTRAINT [ProductImage_isPrimary_df] DEFAULT 0,
    [isActive] BIT NOT NULL CONSTRAINT [ProductImage_isActive_df] DEFAULT 1,
    [createdAt] DATETIME2 NOT NULL CONSTRAINT [ProductImage_createdAt_df] DEFAULT CURRENT_TIMESTAMP,
    [updatedAt] DATETIME2 NOT NULL,
    CONSTRAINT [ProductImage_pkey] PRIMARY KEY CLUSTERED ([id])
);

-- CreateTable
CREATE TABLE [dbo].[ProductOption] (
    [id] UNIQUEIDENTIFIER NOT NULL,
    [productId] UNIQUEIDENTIFIER NOT NULL,
    [code] VARCHAR(50) NOT NULL,
    [name] NVARCHAR(150) NOT NULL,
    [description] NVARCHAR(500),
    [isRequired] BIT NOT NULL CONSTRAINT [ProductOption_isRequired_df] DEFAULT 0,
    [sortOrder] INT NOT NULL CONSTRAINT [ProductOption_sortOrder_df] DEFAULT 0,
    [isActive] BIT NOT NULL CONSTRAINT [ProductOption_isActive_df] DEFAULT 1,
    [createdAt] DATETIME2 NOT NULL CONSTRAINT [ProductOption_createdAt_df] DEFAULT CURRENT_TIMESTAMP,
    [updatedAt] DATETIME2 NOT NULL,
    CONSTRAINT [ProductOption_pkey] PRIMARY KEY CLUSTERED ([id]),
    CONSTRAINT [ProductOption_productId_code_key] UNIQUE NONCLUSTERED ([productId],[code])
);

-- CreateTable
CREATE TABLE [dbo].[ProductOptionValue] (
    [id] UNIQUEIDENTIFIER NOT NULL,
    [productOptionId] UNIQUEIDENTIFIER NOT NULL,
    [code] VARCHAR(50) NOT NULL,
    [name] NVARCHAR(150) NOT NULL,
    [value] NVARCHAR(500),
    [priceModifier] DECIMAL(18,2) NOT NULL CONSTRAINT [ProductOptionValue_priceModifier_df] DEFAULT 0,
    [sortOrder] INT NOT NULL CONSTRAINT [ProductOptionValue_sortOrder_df] DEFAULT 0,
    [isActive] BIT NOT NULL CONSTRAINT [ProductOptionValue_isActive_df] DEFAULT 1,
    [createdAt] DATETIME2 NOT NULL CONSTRAINT [ProductOptionValue_createdAt_df] DEFAULT CURRENT_TIMESTAMP,
    [updatedAt] DATETIME2 NOT NULL,
    CONSTRAINT [ProductOptionValue_pkey] PRIMARY KEY CLUSTERED ([id]),
    CONSTRAINT [ProductOptionValue_productOptionId_code_key] UNIQUE NONCLUSTERED ([productOptionId],[code])
);

-- CreateTable
CREATE TABLE [dbo].[Cart] (
    [id] UNIQUEIDENTIFIER NOT NULL,
    [customerId] UNIQUEIDENTIFIER NOT NULL,
    [createdAt] DATETIME2 NOT NULL CONSTRAINT [Cart_createdAt_df] DEFAULT CURRENT_TIMESTAMP,
    [updatedAt] DATETIME2 NOT NULL,
    CONSTRAINT [Cart_pkey] PRIMARY KEY CLUSTERED ([id])
);

-- CreateTable
CREATE TABLE [dbo].[CartItem] (
    [id] UNIQUEIDENTIFIER NOT NULL,
    [cartId] UNIQUEIDENTIFIER NOT NULL,
    [productId] UNIQUEIDENTIFIER NOT NULL,
    [quantity] INT NOT NULL CONSTRAINT [CartItem_quantity_df] DEFAULT 1,
    [unitPrice] DECIMAL(18,2) NOT NULL,
    [createdAt] DATETIME2 NOT NULL CONSTRAINT [CartItem_createdAt_df] DEFAULT CURRENT_TIMESTAMP,
    [updatedAt] DATETIME2 NOT NULL,
    CONSTRAINT [CartItem_pkey] PRIMARY KEY CLUSTERED ([id])
);

-- CreateTable
CREATE TABLE [dbo].[CartItemOption] (
    [id] UNIQUEIDENTIFIER NOT NULL,
    [cartItemId] UNIQUEIDENTIFIER NOT NULL,
    [productOptionValueId] UNIQUEIDENTIFIER NOT NULL,
    [optionName] NVARCHAR(150) NOT NULL,
    [valueName] NVARCHAR(150) NOT NULL,
    [priceModifier] DECIMAL(18,2) NOT NULL CONSTRAINT [CartItemOption_priceModifier_df] DEFAULT 0,
    [createdAt] DATETIME2 NOT NULL CONSTRAINT [CartItemOption_createdAt_df] DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT [CartItemOption_pkey] PRIMARY KEY CLUSTERED ([id])
);

-- CreateTable
CREATE TABLE [dbo].[Order] (
    [id] UNIQUEIDENTIFIER NOT NULL,
    [customerId] UNIQUEIDENTIFIER NOT NULL,
    [orderNumber] VARCHAR(30) NOT NULL,
    [status] VARCHAR(50) NOT NULL,
    [subtotal] DECIMAL(18,2) NOT NULL,
    [shippingCost] DECIMAL(18,2) NOT NULL CONSTRAINT [Order_shippingCost_df] DEFAULT 0,
    [discount] DECIMAL(18,2) NOT NULL CONSTRAINT [Order_discount_df] DEFAULT 0,
    [tax] DECIMAL(18,2) NOT NULL CONSTRAINT [Order_tax_df] DEFAULT 0,
    [total] DECIMAL(18,2) NOT NULL,
    [recipientName] NVARCHAR(200),
    [recipientPhone] NVARCHAR(30),
    [province] NVARCHAR(100),
    [canton] NVARCHAR(100),
    [district] NVARCHAR(100),
    [addressLine1] NVARCHAR(500),
    [addressLine2] NVARCHAR(500),
    [reference] NVARCHAR(500),
    [shippingMethodId] UNIQUEIDENTIFIER,
    [shippingZoneId] UNIQUEIDENTIFIER,
    [notes] NVARCHAR(1000),
    [createdAt] DATETIME2 NOT NULL CONSTRAINT [Order_createdAt_df] DEFAULT CURRENT_TIMESTAMP,
    [updatedAt] DATETIME2 NOT NULL,
    CONSTRAINT [Order_pkey] PRIMARY KEY CLUSTERED ([id]),
    CONSTRAINT [Order_orderNumber_key] UNIQUE NONCLUSTERED ([orderNumber])
);

-- CreateTable
CREATE TABLE [dbo].[OrderItem] (
    [id] UNIQUEIDENTIFIER NOT NULL,
    [orderId] UNIQUEIDENTIFIER NOT NULL,
    [productId] UNIQUEIDENTIFIER NOT NULL,
    [productName] NVARCHAR(200) NOT NULL,
    [sku] VARCHAR(100) NOT NULL,
    [quantity] INT NOT NULL,
    [unitPrice] DECIMAL(18,2) NOT NULL,
    [subtotal] DECIMAL(18,2) NOT NULL,
    [createdAt] DATETIME2 NOT NULL CONSTRAINT [OrderItem_createdAt_df] DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT [OrderItem_pkey] PRIMARY KEY CLUSTERED ([id])
);

-- CreateTable
CREATE TABLE [dbo].[OrderItemOption] (
    [id] UNIQUEIDENTIFIER NOT NULL,
    [orderItemId] UNIQUEIDENTIFIER NOT NULL,
    [productOptionValueId] UNIQUEIDENTIFIER,
    [optionName] NVARCHAR(150) NOT NULL,
    [valueName] NVARCHAR(150) NOT NULL,
    [priceModifier] DECIMAL(18,2) NOT NULL CONSTRAINT [OrderItemOption_priceModifier_df] DEFAULT 0,
    [createdAt] DATETIME2 NOT NULL CONSTRAINT [OrderItemOption_createdAt_df] DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT [OrderItemOption_pkey] PRIMARY KEY CLUSTERED ([id])
);

-- CreateTable
CREATE TABLE [dbo].[OrderStatusHistory] (
    [id] UNIQUEIDENTIFIER NOT NULL,
    [orderId] UNIQUEIDENTIFIER NOT NULL,
    [status] VARCHAR(50) NOT NULL,
    [comment] NVARCHAR(1000),
    [createdAt] DATETIME2 NOT NULL CONSTRAINT [OrderStatusHistory_createdAt_df] DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT [OrderStatusHistory_pkey] PRIMARY KEY CLUSTERED ([id])
);

-- CreateTable
CREATE TABLE [dbo].[Payment] (
    [id] UNIQUEIDENTIFIER NOT NULL,
    [orderId] UNIQUEIDENTIFIER NOT NULL,
    [status] VARCHAR(50) NOT NULL,
    [method] VARCHAR(50) NOT NULL,
    [amount] DECIMAL(18,2) NOT NULL,
    [currency] CHAR(3) NOT NULL CONSTRAINT [Payment_currency_df] DEFAULT 'CRC',
    [transactionId] NVARCHAR(255),
    [provider] NVARCHAR(100),
    [paidAt] DATETIME2,
    [failureReason] NVARCHAR(1000),
    [createdAt] DATETIME2 NOT NULL CONSTRAINT [Payment_createdAt_df] DEFAULT CURRENT_TIMESTAMP,
    [updatedAt] DATETIME2 NOT NULL,
    CONSTRAINT [Payment_pkey] PRIMARY KEY CLUSTERED ([id]),
    CONSTRAINT [Payment_orderId_key] UNIQUE NONCLUSTERED ([orderId])
);

-- CreateTable
CREATE TABLE [dbo].[ShippingMethod] (
    [id] UNIQUEIDENTIFIER NOT NULL,
    [code] VARCHAR(50) NOT NULL,
    [name] NVARCHAR(150) NOT NULL,
    [description] NVARCHAR(500),
    [type] VARCHAR(30) NOT NULL,
    [basePrice] DECIMAL(18,2) NOT NULL CONSTRAINT [ShippingMethod_basePrice_df] DEFAULT 0,
    [isActive] BIT NOT NULL CONSTRAINT [ShippingMethod_isActive_df] DEFAULT 1,
    [createdAt] DATETIME2 NOT NULL CONSTRAINT [ShippingMethod_createdAt_df] DEFAULT CURRENT_TIMESTAMP,
    [updatedAt] DATETIME2 NOT NULL,
    CONSTRAINT [ShippingMethod_pkey] PRIMARY KEY CLUSTERED ([id]),
    CONSTRAINT [ShippingMethod_code_key] UNIQUE NONCLUSTERED ([code])
);

-- CreateTable
CREATE TABLE [dbo].[ShippingZone] (
    [id] UNIQUEIDENTIFIER NOT NULL,
    [code] VARCHAR(50) NOT NULL,
    [name] NVARCHAR(150) NOT NULL,
    [description] NVARCHAR(500),
    [isActive] BIT NOT NULL CONSTRAINT [ShippingZone_isActive_df] DEFAULT 1,
    [createdAt] DATETIME2 NOT NULL CONSTRAINT [ShippingZone_createdAt_df] DEFAULT CURRENT_TIMESTAMP,
    [updatedAt] DATETIME2 NOT NULL,
    CONSTRAINT [ShippingZone_pkey] PRIMARY KEY CLUSTERED ([id]),
    CONSTRAINT [ShippingZone_code_key] UNIQUE NONCLUSTERED ([code])
);

-- CreateTable
CREATE TABLE [dbo].[DesignService] (
    [id] UNIQUEIDENTIFIER NOT NULL,
    [code] VARCHAR(50) NOT NULL,
    [name] NVARCHAR(200) NOT NULL,
    [description] NVARCHAR(2000),
    [basePrice] DECIMAL(18,2),
    [requiresQuote] BIT NOT NULL CONSTRAINT [DesignService_requiresQuote_df] DEFAULT 1,
    [isActive] BIT NOT NULL CONSTRAINT [DesignService_isActive_df] DEFAULT 1,
    [createdAt] DATETIME2 NOT NULL CONSTRAINT [DesignService_createdAt_df] DEFAULT CURRENT_TIMESTAMP,
    [updatedAt] DATETIME2 NOT NULL,
    CONSTRAINT [DesignService_pkey] PRIMARY KEY CLUSTERED ([id]),
    CONSTRAINT [DesignService_code_key] UNIQUE NONCLUSTERED ([code])
);

-- CreateTable
CREATE TABLE [dbo].[DesignRequest] (
    [id] UNIQUEIDENTIFIER NOT NULL,
    [customerId] UNIQUEIDENTIFIER NOT NULL,
    [designServiceId] UNIQUEIDENTIFIER NOT NULL,
    [requestNumber] VARCHAR(30) NOT NULL,
    [status] VARCHAR(50) NOT NULL,
    [title] NVARCHAR(200) NOT NULL,
    [description] NVARCHAR(3000) NOT NULL,
    [quotedPrice] DECIMAL(18,2),
    [customerNotes] NVARCHAR(2000),
    [internalNotes] NVARCHAR(2000),
    [approvedAt] DATETIME2,
    [completedAt] DATETIME2,
    [createdAt] DATETIME2 NOT NULL CONSTRAINT [DesignRequest_createdAt_df] DEFAULT CURRENT_TIMESTAMP,
    [updatedAt] DATETIME2 NOT NULL,
    CONSTRAINT [DesignRequest_pkey] PRIMARY KEY CLUSTERED ([id]),
    CONSTRAINT [DesignRequest_requestNumber_key] UNIQUE NONCLUSTERED ([requestNumber])
);

-- CreateTable
CREATE TABLE [dbo].[DesignAssignment] (
    [id] UNIQUEIDENTIFIER NOT NULL,
    [designRequestId] UNIQUEIDENTIFIER NOT NULL,
    [designerId] UNIQUEIDENTIFIER NOT NULL,
    [status] VARCHAR(50) NOT NULL,
    [assignedAt] DATETIME2 NOT NULL CONSTRAINT [DesignAssignment_assignedAt_df] DEFAULT CURRENT_TIMESTAMP,
    [completedAt] DATETIME2,
    [notes] NVARCHAR(1000),
    CONSTRAINT [DesignAssignment_pkey] PRIMARY KEY CLUSTERED ([id])
);

-- CreateTable
CREATE TABLE [dbo].[DesignRevision] (
    [id] UNIQUEIDENTIFIER NOT NULL,
    [designRequestId] UNIQUEIDENTIFIER NOT NULL,
    [createdById] UNIQUEIDENTIFIER NOT NULL,
    [version] INT NOT NULL,
    [status] VARCHAR(50) NOT NULL,
    [comment] NVARCHAR(2000),
    [createdAt] DATETIME2 NOT NULL CONSTRAINT [DesignRevision_createdAt_df] DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT [DesignRevision_pkey] PRIMARY KEY CLUSTERED ([id]),
    CONSTRAINT [DesignRevision_designRequestId_version_key] UNIQUE NONCLUSTERED ([designRequestId],[version])
);

-- CreateTable
CREATE TABLE [dbo].[File] (
    [id] UNIQUEIDENTIFIER NOT NULL,
    [designRequestId] UNIQUEIDENTIFIER,
    [designRevisionId] UNIQUEIDENTIFIER,
    [uploadedById] UNIQUEIDENTIFIER NOT NULL,
    [storageProvider] VARCHAR(50) NOT NULL CONSTRAINT [File_storageProvider_df] DEFAULT 'AZURE_BLOB',
    [containerName] NVARCHAR(255) NOT NULL,
    [storageKey] NVARCHAR(1000) NOT NULL,
    [fileName] NVARCHAR(255) NOT NULL,
    [contentType] VARCHAR(150) NOT NULL,
    [extension] VARCHAR(20),
    [sizeBytes] BIGINT NOT NULL,
    [description] NVARCHAR(500),
    [isActive] BIT NOT NULL CONSTRAINT [File_isActive_df] DEFAULT 1,
    [createdAt] DATETIME2 NOT NULL CONSTRAINT [File_createdAt_df] DEFAULT CURRENT_TIMESTAMP,
    [updatedAt] DATETIME2 NOT NULL,
    CONSTRAINT [File_pkey] PRIMARY KEY CLUSTERED ([id])
);

-- CreateIndex
CREATE NONCLUSTERED INDEX [User_email_idx] ON [dbo].[User]([email]);

-- CreateIndex
CREATE NONCLUSTERED INDEX [User_isActive_idx] ON [dbo].[User]([isActive]);

-- CreateIndex
CREATE NONCLUSTERED INDEX [UserRole_userId_idx] ON [dbo].[UserRole]([userId]);

-- CreateIndex
CREATE NONCLUSTERED INDEX [UserRole_roleId_idx] ON [dbo].[UserRole]([roleId]);

-- CreateIndex
CREATE NONCLUSTERED INDEX [Customer_email_idx] ON [dbo].[Customer]([email]);

-- CreateIndex
CREATE NONCLUSTERED INDEX [Customer_phone_idx] ON [dbo].[Customer]([phone]);

-- CreateIndex
CREATE NONCLUSTERED INDEX [Customer_isActive_idx] ON [dbo].[Customer]([isActive]);

-- CreateIndex
CREATE NONCLUSTERED INDEX [Address_customerId_idx] ON [dbo].[Address]([customerId]);

-- CreateIndex
CREATE NONCLUSTERED INDEX [Address_province_canton_district_idx] ON [dbo].[Address]([province], [canton], [district]);

-- CreateIndex
CREATE NONCLUSTERED INDEX [Category_isActive_idx] ON [dbo].[Category]([isActive]);

-- CreateIndex
CREATE NONCLUSTERED INDEX [Category_sortOrder_idx] ON [dbo].[Category]([sortOrder]);

-- CreateIndex
CREATE NONCLUSTERED INDEX [Product_categoryId_idx] ON [dbo].[Product]([categoryId]);

-- CreateIndex
CREATE NONCLUSTERED INDEX [Product_isActive_idx] ON [dbo].[Product]([isActive]);

-- CreateIndex
CREATE NONCLUSTERED INDEX [Product_name_idx] ON [dbo].[Product]([name]);

-- CreateIndex
CREATE NONCLUSTERED INDEX [ProductImage_productId_idx] ON [dbo].[ProductImage]([productId]);

-- CreateIndex
CREATE NONCLUSTERED INDEX [ProductImage_productId_sortOrder_idx] ON [dbo].[ProductImage]([productId], [sortOrder]);

-- CreateIndex
CREATE NONCLUSTERED INDEX [ProductOption_productId_idx] ON [dbo].[ProductOption]([productId]);

-- CreateIndex
CREATE NONCLUSTERED INDEX [ProductOptionValue_productOptionId_idx] ON [dbo].[ProductOptionValue]([productOptionId]);

-- CreateIndex
CREATE NONCLUSTERED INDEX [Cart_customerId_idx] ON [dbo].[Cart]([customerId]);

-- CreateIndex
CREATE NONCLUSTERED INDEX [CartItem_cartId_idx] ON [dbo].[CartItem]([cartId]);

-- CreateIndex
CREATE NONCLUSTERED INDEX [CartItem_productId_idx] ON [dbo].[CartItem]([productId]);

-- CreateIndex
CREATE NONCLUSTERED INDEX [CartItemOption_cartItemId_idx] ON [dbo].[CartItemOption]([cartItemId]);

-- CreateIndex
CREATE NONCLUSTERED INDEX [CartItemOption_productOptionValueId_idx] ON [dbo].[CartItemOption]([productOptionValueId]);

-- CreateIndex
CREATE NONCLUSTERED INDEX [Order_customerId_idx] ON [dbo].[Order]([customerId]);

-- CreateIndex
CREATE NONCLUSTERED INDEX [Order_status_idx] ON [dbo].[Order]([status]);

-- CreateIndex
CREATE NONCLUSTERED INDEX [Order_createdAt_idx] ON [dbo].[Order]([createdAt]);

-- CreateIndex
CREATE NONCLUSTERED INDEX [Order_shippingMethodId_idx] ON [dbo].[Order]([shippingMethodId]);

-- CreateIndex
CREATE NONCLUSTERED INDEX [Order_shippingZoneId_idx] ON [dbo].[Order]([shippingZoneId]);

-- CreateIndex
CREATE NONCLUSTERED INDEX [OrderItem_orderId_idx] ON [dbo].[OrderItem]([orderId]);

-- CreateIndex
CREATE NONCLUSTERED INDEX [OrderItem_productId_idx] ON [dbo].[OrderItem]([productId]);

-- CreateIndex
CREATE NONCLUSTERED INDEX [OrderItemOption_orderItemId_idx] ON [dbo].[OrderItemOption]([orderItemId]);

-- CreateIndex
CREATE NONCLUSTERED INDEX [OrderItemOption_productOptionValueId_idx] ON [dbo].[OrderItemOption]([productOptionValueId]);

-- CreateIndex
CREATE NONCLUSTERED INDEX [OrderStatusHistory_orderId_idx] ON [dbo].[OrderStatusHistory]([orderId]);

-- CreateIndex
CREATE NONCLUSTERED INDEX [OrderStatusHistory_orderId_createdAt_idx] ON [dbo].[OrderStatusHistory]([orderId], [createdAt]);

-- CreateIndex
CREATE NONCLUSTERED INDEX [Payment_status_idx] ON [dbo].[Payment]([status]);

-- CreateIndex
CREATE NONCLUSTERED INDEX [Payment_transactionId_idx] ON [dbo].[Payment]([transactionId]);

-- CreateIndex
CREATE NONCLUSTERED INDEX [ShippingMethod_type_idx] ON [dbo].[ShippingMethod]([type]);

-- CreateIndex
CREATE NONCLUSTERED INDEX [ShippingMethod_isActive_idx] ON [dbo].[ShippingMethod]([isActive]);

-- CreateIndex
CREATE NONCLUSTERED INDEX [ShippingZone_isActive_idx] ON [dbo].[ShippingZone]([isActive]);

-- CreateIndex
CREATE NONCLUSTERED INDEX [DesignService_isActive_idx] ON [dbo].[DesignService]([isActive]);

-- CreateIndex
CREATE NONCLUSTERED INDEX [DesignRequest_customerId_idx] ON [dbo].[DesignRequest]([customerId]);

-- CreateIndex
CREATE NONCLUSTERED INDEX [DesignRequest_designServiceId_idx] ON [dbo].[DesignRequest]([designServiceId]);

-- CreateIndex
CREATE NONCLUSTERED INDEX [DesignRequest_status_idx] ON [dbo].[DesignRequest]([status]);

-- CreateIndex
CREATE NONCLUSTERED INDEX [DesignRequest_createdAt_idx] ON [dbo].[DesignRequest]([createdAt]);

-- CreateIndex
CREATE NONCLUSTERED INDEX [DesignAssignment_designRequestId_idx] ON [dbo].[DesignAssignment]([designRequestId]);

-- CreateIndex
CREATE NONCLUSTERED INDEX [DesignAssignment_designerId_idx] ON [dbo].[DesignAssignment]([designerId]);

-- CreateIndex
CREATE NONCLUSTERED INDEX [DesignAssignment_status_idx] ON [dbo].[DesignAssignment]([status]);

-- CreateIndex
CREATE NONCLUSTERED INDEX [DesignRevision_designRequestId_idx] ON [dbo].[DesignRevision]([designRequestId]);

-- CreateIndex
CREATE NONCLUSTERED INDEX [DesignRevision_createdById_idx] ON [dbo].[DesignRevision]([createdById]);

-- CreateIndex
CREATE NONCLUSTERED INDEX [File_designRequestId_idx] ON [dbo].[File]([designRequestId]);

-- CreateIndex
CREATE NONCLUSTERED INDEX [File_designRevisionId_idx] ON [dbo].[File]([designRevisionId]);

-- CreateIndex
CREATE NONCLUSTERED INDEX [File_uploadedById_idx] ON [dbo].[File]([uploadedById]);

-- CreateIndex
CREATE NONCLUSTERED INDEX [File_createdAt_idx] ON [dbo].[File]([createdAt]);

-- AddForeignKey
ALTER TABLE [dbo].[UserRole] ADD CONSTRAINT [UserRole_userId_fkey] FOREIGN KEY ([userId]) REFERENCES [dbo].[User]([id]) ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[UserRole] ADD CONSTRAINT [UserRole_roleId_fkey] FOREIGN KEY ([roleId]) REFERENCES [dbo].[Role]([id]) ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[Customer] ADD CONSTRAINT [Customer_userId_fkey] FOREIGN KEY ([userId]) REFERENCES [dbo].[User]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[Address] ADD CONSTRAINT [Address_customerId_fkey] FOREIGN KEY ([customerId]) REFERENCES [dbo].[Customer]([id]) ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[Product] ADD CONSTRAINT [Product_categoryId_fkey] FOREIGN KEY ([categoryId]) REFERENCES [dbo].[Category]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[ProductImage] ADD CONSTRAINT [ProductImage_productId_fkey] FOREIGN KEY ([productId]) REFERENCES [dbo].[Product]([id]) ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[ProductOption] ADD CONSTRAINT [ProductOption_productId_fkey] FOREIGN KEY ([productId]) REFERENCES [dbo].[Product]([id]) ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[ProductOptionValue] ADD CONSTRAINT [ProductOptionValue_productOptionId_fkey] FOREIGN KEY ([productOptionId]) REFERENCES [dbo].[ProductOption]([id]) ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[Cart] ADD CONSTRAINT [Cart_customerId_fkey] FOREIGN KEY ([customerId]) REFERENCES [dbo].[Customer]([id]) ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[CartItem] ADD CONSTRAINT [CartItem_cartId_fkey] FOREIGN KEY ([cartId]) REFERENCES [dbo].[Cart]([id]) ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[CartItem] ADD CONSTRAINT [CartItem_productId_fkey] FOREIGN KEY ([productId]) REFERENCES [dbo].[Product]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[CartItemOption] ADD CONSTRAINT [CartItemOption_cartItemId_fkey] FOREIGN KEY ([cartItemId]) REFERENCES [dbo].[CartItem]([id]) ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[CartItemOption] ADD CONSTRAINT [CartItemOption_productOptionValueId_fkey] FOREIGN KEY ([productOptionValueId]) REFERENCES [dbo].[ProductOptionValue]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[Order] ADD CONSTRAINT [Order_customerId_fkey] FOREIGN KEY ([customerId]) REFERENCES [dbo].[Customer]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[Order] ADD CONSTRAINT [Order_shippingMethodId_fkey] FOREIGN KEY ([shippingMethodId]) REFERENCES [dbo].[ShippingMethod]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[Order] ADD CONSTRAINT [Order_shippingZoneId_fkey] FOREIGN KEY ([shippingZoneId]) REFERENCES [dbo].[ShippingZone]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[OrderItem] ADD CONSTRAINT [OrderItem_orderId_fkey] FOREIGN KEY ([orderId]) REFERENCES [dbo].[Order]([id]) ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[OrderItem] ADD CONSTRAINT [OrderItem_productId_fkey] FOREIGN KEY ([productId]) REFERENCES [dbo].[Product]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[OrderItemOption] ADD CONSTRAINT [OrderItemOption_orderItemId_fkey] FOREIGN KEY ([orderItemId]) REFERENCES [dbo].[OrderItem]([id]) ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[OrderItemOption] ADD CONSTRAINT [OrderItemOption_productOptionValueId_fkey] FOREIGN KEY ([productOptionValueId]) REFERENCES [dbo].[ProductOptionValue]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[OrderStatusHistory] ADD CONSTRAINT [OrderStatusHistory_orderId_fkey] FOREIGN KEY ([orderId]) REFERENCES [dbo].[Order]([id]) ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[Payment] ADD CONSTRAINT [Payment_orderId_fkey] FOREIGN KEY ([orderId]) REFERENCES [dbo].[Order]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[DesignRequest] ADD CONSTRAINT [DesignRequest_customerId_fkey] FOREIGN KEY ([customerId]) REFERENCES [dbo].[Customer]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[DesignRequest] ADD CONSTRAINT [DesignRequest_designServiceId_fkey] FOREIGN KEY ([designServiceId]) REFERENCES [dbo].[DesignService]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[DesignAssignment] ADD CONSTRAINT [DesignAssignment_designRequestId_fkey] FOREIGN KEY ([designRequestId]) REFERENCES [dbo].[DesignRequest]([id]) ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[DesignAssignment] ADD CONSTRAINT [DesignAssignment_designerId_fkey] FOREIGN KEY ([designerId]) REFERENCES [dbo].[User]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[DesignRevision] ADD CONSTRAINT [DesignRevision_designRequestId_fkey] FOREIGN KEY ([designRequestId]) REFERENCES [dbo].[DesignRequest]([id]) ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[DesignRevision] ADD CONSTRAINT [DesignRevision_createdById_fkey] FOREIGN KEY ([createdById]) REFERENCES [dbo].[User]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[File] ADD CONSTRAINT [File_designRequestId_fkey] FOREIGN KEY ([designRequestId]) REFERENCES [dbo].[DesignRequest]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[File] ADD CONSTRAINT [File_designRevisionId_fkey] FOREIGN KEY ([designRevisionId]) REFERENCES [dbo].[DesignRevision]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[File] ADD CONSTRAINT [File_uploadedById_fkey] FOREIGN KEY ([uploadedById]) REFERENCES [dbo].[User]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

COMMIT TRAN;

END TRY
BEGIN CATCH

IF @@TRANCOUNT > 0
BEGIN
    ROLLBACK TRAN;
END;
THROW

END CATCH
