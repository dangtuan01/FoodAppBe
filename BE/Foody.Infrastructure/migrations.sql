IF OBJECT_ID(N'[__EFMigrationsHistory]') IS NULL
BEGIN
    CREATE TABLE [__EFMigrationsHistory] (
        [MigrationId] nvarchar(150) NOT NULL,
        [ProductVersion] nvarchar(32) NOT NULL,
        CONSTRAINT [PK___EFMigrationsHistory] PRIMARY KEY ([MigrationId])
    );
END;
GO

BEGIN TRANSACTION;
GO

CREATE TABLE [Carts] (
    [Id] int NOT NULL IDENTITY,
    [UserId] int NOT NULL,
    [CreatedAt] datetime2 NOT NULL,
    [CreatedBy] int NOT NULL,
    [IsDeleted] bit NOT NULL,
    CONSTRAINT [PK_Carts] PRIMARY KEY ([Id])
);
GO

CREATE TABLE [Category] (
    [Id] int NOT NULL IDENTITY,
    [Name] nvarchar(250) NOT NULL,
    [Description] nvarchar(250) NULL,
    [IsDeleted] bit NOT NULL,
    [CreatedAt] datetime2 NOT NULL,
    [CreatedBy] int NOT NULL,
    [UpdatedAt] datetime2 NOT NULL,
    [UpdateBy] int NOT NULL,
    CONSTRAINT [PK_Category] PRIMARY KEY ([Id])
);
GO

CREATE TABLE [Promotion] (
    [Id] int NOT NULL IDENTITY,
    [Name] nvarchar(250) NOT NULL,
    [PromotionCode] nvarchar(max) NULL,
    [Description] nvarchar(250) NULL,
    [DiscountPercent] float NOT NULL,
    [StartTime] datetime2 NOT NULL,
    [EndTime] datetime2 NOT NULL,
    [IsActive] bit NOT NULL,
    [CreatedAt] datetime2 NOT NULL,
    [CreatedBy] int NOT NULL,
    [UpdatedAt] datetime2 NOT NULL,
    [UpdateBy] int NOT NULL,
    [IsDeleted] bit NOT NULL,
    CONSTRAINT [PK_Promotion] PRIMARY KEY ([Id])
);
GO

CREATE TABLE [User] (
    [Id] int NOT NULL IDENTITY,
    [FirstName] nvarchar(250) NULL,
    [LastName] nvarchar(250) NULL,
    [PhoneNumber] nvarchar(20) NULL,
    [Email] nvarchar(250) NOT NULL,
    [Password] nvarchar(250) NOT NULL,
    [UserType] int NOT NULL,
    [RefreshToken] nvarchar(max) NULL,
    [RefreshTokenExpiryTime] datetime2 NOT NULL,
    [CreatedAt] datetime2 NOT NULL,
    [CreatedBy] int NOT NULL,
    CONSTRAINT [PK_User] PRIMARY KEY ([Id])
);
GO

CREATE TABLE [Product] (
    [Id] int NOT NULL IDENTITY,
    [Name] nvarchar(250) NOT NULL,
    [Price] float NOT NULL,
    [ActualPrice] float NOT NULL,
    [Description] nvarchar(250) NOT NULL,
    [CategoryId] int NOT NULL,
    [IsActived] bit NOT NULL,
    [IsDeleted] bit NOT NULL,
    [UpdatedAt] datetime2 NOT NULL,
    [UpdateBy] int NOT NULL,
    [CreatedAt] datetime2 NOT NULL,
    [CreatedBy] int NOT NULL,
    CONSTRAINT [PK_Product] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_Product_Category_CategoryId] FOREIGN KEY ([CategoryId]) REFERENCES [Category] ([Id]) ON DELETE CASCADE
);
GO

CREATE TABLE [Order] (
    [Id] int NOT NULL IDENTITY,
    [UserId] int NOT NULL,
    [Status] int NOT NULL,
    [PaymentMethod] int NOT NULL,
    [Province] nvarchar(max) NULL,
    [District] nvarchar(max) NULL,
    [Ward] nvarchar(max) NULL,
    [StreetAddress] nvarchar(max) NULL,
    [DetailAddress] nvarchar(250) NOT NULL,
    [Notes] nvarchar(250) NULL,
    [AddressType] int NOT NULL,
    [IsPaid] bit NOT NULL,
    [IsDeleted] bit NOT NULL,
    [CreatedAt] datetime2 NOT NULL,
    [CreatedBy] int NOT NULL,
    [UpdatedAt] datetime2 NOT NULL,
    [UpdateBy] int NOT NULL,
    CONSTRAINT [PK_Order] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_Order_User_UserId] FOREIGN KEY ([UserId]) REFERENCES [User] ([Id]) ON DELETE CASCADE
);
GO

CREATE TABLE [UserAddresses] (
    [Id] int NOT NULL IDENTITY,
    [UserId] int NOT NULL,
    [Province] nvarchar(max) NULL,
    [District] nvarchar(max) NULL,
    [Ward] nvarchar(max) NULL,
    [StreetAddress] nvarchar(max) NULL,
    [DetailAddress] nvarchar(250) NOT NULL,
    [Notes] nvarchar(250) NULL,
    [AddressType] int NOT NULL,
    [CreatedAt] datetime2 NOT NULL,
    [CreatedBy] int NOT NULL,
    [UpdatedAt] datetime2 NOT NULL,
    [UpdateBy] int NOT NULL,
    CONSTRAINT [PK_UserAddresses] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_UserAddresses_User_UserId] FOREIGN KEY ([UserId]) REFERENCES [User] ([Id]) ON DELETE CASCADE
);
GO

CREATE TABLE [ProductImages] (
    [Id] int NOT NULL IDENTITY,
    [Description] nvarchar(max) NULL,
    [ProductImageUrl] nvarchar(max) NULL,
    [FileSize] bigint NOT NULL,
    [ProductId] int NOT NULL,
    [UpdatedAt] datetime2 NOT NULL,
    [UpdateBy] int NOT NULL,
    [CreatedAt] datetime2 NOT NULL,
    [CreatedBy] int NOT NULL,
    [IsDeleted] bit NOT NULL,
    CONSTRAINT [PK_ProductImages] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_ProductImages_Product_ProductId] FOREIGN KEY ([ProductId]) REFERENCES [Product] ([Id]) ON DELETE CASCADE
);
GO

CREATE TABLE [ProductPromotions] (
    [Id] int NOT NULL IDENTITY,
    [ProductId] int NOT NULL,
    [PromotionId] int NOT NULL,
    [IsActive] bit NOT NULL,
    CONSTRAINT [PK_ProductPromotions] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_ProductPromotions_Product_ProductId] FOREIGN KEY ([ProductId]) REFERENCES [Product] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_ProductPromotions_Promotion_PromotionId] FOREIGN KEY ([PromotionId]) REFERENCES [Promotion] ([Id]) ON DELETE CASCADE
);
GO

CREATE TABLE [ProductsCarts] (
    [Id] int NOT NULL IDENTITY,
    [Quantity] int NOT NULL,
    [ProductId] int NOT NULL,
    [CartId] int NOT NULL,
    [IsDeleted] bit NOT NULL,
    CONSTRAINT [PK_ProductsCarts] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_ProductsCarts_Carts_CartId] FOREIGN KEY ([CartId]) REFERENCES [Carts] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_ProductsCarts_Product_ProductId] FOREIGN KEY ([ProductId]) REFERENCES [Product] ([Id]) ON DELETE CASCADE
);
GO

CREATE TABLE [OrderDetails] (
    [Id] int NOT NULL IDENTITY,
    [Quantity] int NOT NULL,
    [OrderId] int NOT NULL,
    [ProductId] int NOT NULL,
    [IsDeleted] bit NOT NULL,
    CONSTRAINT [PK_OrderDetails] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_OrderDetails_Order_OrderId] FOREIGN KEY ([OrderId]) REFERENCES [Order] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_OrderDetails_Product_ProductId] FOREIGN KEY ([ProductId]) REFERENCES [Product] ([Id]) ON DELETE CASCADE
);
GO

IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'Id', N'CreatedAt', N'CreatedBy', N'Description', N'IsDeleted', N'Name', N'UpdateBy', N'UpdatedAt') AND [object_id] = OBJECT_ID(N'[Category]'))
    SET IDENTITY_INSERT [Category] ON;
INSERT INTO [Category] ([Id], [CreatedAt], [CreatedBy], [Description], [IsDeleted], [Name], [UpdateBy], [UpdatedAt])
VALUES (1, '2023-11-01T08:48:24.2021880+07:00', 0, N'Các món cơm', CAST(0 AS bit), N'Cơm', 0, '0001-01-01T00:00:00.0000000'),
(2, '2023-11-01T08:48:24.2021892+07:00', 0, N'Các món ăn nhanh', CAST(0 AS bit), N'Đồ ăn nhanh', 0, '0001-01-01T00:00:00.0000000'),
(3, '2023-11-01T08:48:24.2021893+07:00', 0, N'Các đồ uống', CAST(0 AS bit), N'Đồ uống', 0, '0001-01-01T00:00:00.0000000'),
(4, '2023-11-01T08:48:24.2021895+07:00', 0, N'Các món bún', CAST(0 AS bit), N'Bún', 0, '0001-01-01T00:00:00.0000000'),
(5, '2023-11-01T08:48:24.2021896+07:00', 0, N'Các món mì', CAST(0 AS bit), N'Mì', 0, '0001-01-01T00:00:00.0000000');
IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'Id', N'CreatedAt', N'CreatedBy', N'Description', N'IsDeleted', N'Name', N'UpdateBy', N'UpdatedAt') AND [object_id] = OBJECT_ID(N'[Category]'))
    SET IDENTITY_INSERT [Category] OFF;
GO

IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'Id', N'CreatedAt', N'CreatedBy', N'Description', N'DiscountPercent', N'EndTime', N'IsActive', N'IsDeleted', N'Name', N'PromotionCode', N'StartTime', N'UpdateBy', N'UpdatedAt') AND [object_id] = OBJECT_ID(N'[Promotion]'))
    SET IDENTITY_INSERT [Promotion] ON;
INSERT INTO [Promotion] ([Id], [CreatedAt], [CreatedBy], [Description], [DiscountPercent], [EndTime], [IsActive], [IsDeleted], [Name], [PromotionCode], [StartTime], [UpdateBy], [UpdatedAt])
VALUES (1, '0001-01-01T00:00:00.0000000', 0, N'Không giảm giá', 0.0E0, '0001-01-01T00:00:00.0000000', CAST(1 AS bit), CAST(0 AS bit), N'Không giảm giá', NULL, '0001-01-01T00:00:00.0000000', 0, '0001-01-01T00:00:00.0000000'),
(5, '0001-01-01T00:00:00.0000000', 0, N'Giảm giá 5%', 5.0E0, '0001-01-01T00:00:00.0000000', CAST(1 AS bit), CAST(0 AS bit), N'Giảm giá 5%', NULL, '0001-01-01T00:00:00.0000000', 0, '0001-01-01T00:00:00.0000000'),
(10, '0001-01-01T00:00:00.0000000', 0, N'Giảm giá 10%', 10.0E0, '0001-01-01T00:00:00.0000000', CAST(1 AS bit), CAST(0 AS bit), N'Giảm giá 10%', NULL, '0001-01-01T00:00:00.0000000', 0, '0001-01-01T00:00:00.0000000'),
(20, '0001-01-01T00:00:00.0000000', 0, N'Giảm giá 20%', 20.0E0, '0001-01-01T00:00:00.0000000', CAST(1 AS bit), CAST(0 AS bit), N'Giảm giá 20%', NULL, '0001-01-01T00:00:00.0000000', 0, '0001-01-01T00:00:00.0000000'),
(25, '0001-01-01T00:00:00.0000000', 0, N'Giảm giá 25%', 25.0E0, '0001-01-01T00:00:00.0000000', CAST(1 AS bit), CAST(0 AS bit), N'Giảm giá 25%', NULL, '0001-01-01T00:00:00.0000000', 0, '0001-01-01T00:00:00.0000000'),
(50, '0001-01-01T00:00:00.0000000', 0, N'Giảm giá 50%', 50.0E0, '0001-01-01T00:00:00.0000000', CAST(1 AS bit), CAST(0 AS bit), N'Giảm giá 50%', NULL, '0001-01-01T00:00:00.0000000', 0, '0001-01-01T00:00:00.0000000');
IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'Id', N'CreatedAt', N'CreatedBy', N'Description', N'DiscountPercent', N'EndTime', N'IsActive', N'IsDeleted', N'Name', N'PromotionCode', N'StartTime', N'UpdateBy', N'UpdatedAt') AND [object_id] = OBJECT_ID(N'[Promotion]'))
    SET IDENTITY_INSERT [Promotion] OFF;
GO

IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'Id', N'CreatedAt', N'CreatedBy', N'Email', N'FirstName', N'LastName', N'Password', N'PhoneNumber', N'RefreshToken', N'RefreshTokenExpiryTime', N'UserType') AND [object_id] = OBJECT_ID(N'[User]'))
    SET IDENTITY_INSERT [User] ON;
INSERT INTO [User] ([Id], [CreatedAt], [CreatedBy], [Email], [FirstName], [LastName], [Password], [PhoneNumber], [RefreshToken], [RefreshTokenExpiryTime], [UserType])
VALUES (1, '2023-11-01T08:48:24.1937870+07:00', 0, N'Admin@gmail.com', NULL, NULL, N'hNfjELLD+xYcftRqvoOyY3Embgt5EdEXeLtDFx8gaa66BkVg', NULL, NULL, '0001-01-01T00:00:00.0000000', 1),
(2, '2023-11-01T08:48:24.1970345+07:00', 0, N'Customer@gmail.com', NULL, NULL, N'8aJDt0Mbq0D61QRT+x9Flc6EdT9IceLRgpfpVflDsbV3EhNS', NULL, NULL, '0001-01-01T00:00:00.0000000', 2);
IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'Id', N'CreatedAt', N'CreatedBy', N'Email', N'FirstName', N'LastName', N'Password', N'PhoneNumber', N'RefreshToken', N'RefreshTokenExpiryTime', N'UserType') AND [object_id] = OBJECT_ID(N'[User]'))
    SET IDENTITY_INSERT [User] OFF;
GO

CREATE INDEX [IX_Order_UserId] ON [Order] ([UserId]);
GO

CREATE INDEX [IX_OrderDetails_OrderId] ON [OrderDetails] ([OrderId]);
GO

CREATE INDEX [IX_OrderDetails_ProductId] ON [OrderDetails] ([ProductId]);
GO

CREATE INDEX [IX_Product_CategoryId] ON [Product] ([CategoryId]);
GO

CREATE INDEX [IX_ProductImages_ProductId] ON [ProductImages] ([ProductId]);
GO

CREATE INDEX [IX_ProductPromotions_ProductId] ON [ProductPromotions] ([ProductId]);
GO

CREATE INDEX [IX_ProductPromotions_PromotionId] ON [ProductPromotions] ([PromotionId]);
GO

CREATE INDEX [IX_ProductsCarts_CartId] ON [ProductsCarts] ([CartId]);
GO

CREATE INDEX [IX_ProductsCarts_ProductId] ON [ProductsCarts] ([ProductId]);
GO

CREATE INDEX [IX_UserAddresses_UserId] ON [UserAddresses] ([UserId]);
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20231101014824_InitDb', N'7.0.11');
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

UPDATE [Category] SET [CreatedAt] = '2024-06-21T21:16:45.4875609+07:00'
WHERE [Id] = 1;
SELECT @@ROWCOUNT;

GO

UPDATE [Category] SET [CreatedAt] = '2024-06-21T21:16:45.4875623+07:00'
WHERE [Id] = 2;
SELECT @@ROWCOUNT;

GO

UPDATE [Category] SET [CreatedAt] = '2024-06-21T21:16:45.4875625+07:00'
WHERE [Id] = 3;
SELECT @@ROWCOUNT;

GO

UPDATE [Category] SET [CreatedAt] = '2024-06-21T21:16:45.4875627+07:00'
WHERE [Id] = 4;
SELECT @@ROWCOUNT;

GO

UPDATE [Category] SET [CreatedAt] = '2024-06-21T21:16:45.4875629+07:00'
WHERE [Id] = 5;
SELECT @@ROWCOUNT;

GO

UPDATE [User] SET [CreatedAt] = '2024-06-21T21:16:45.4661071+07:00', [Password] = N'th5sZLuXXVdoa8glnrRpt+F3fbj5uTcbM/b4ze9NNdeoI+GY'
WHERE [Id] = 1;
SELECT @@ROWCOUNT;

GO

UPDATE [User] SET [CreatedAt] = '2024-06-21T21:16:45.4754589+07:00', [Password] = N'acxHj4OPlDkcgPl31sNwSFr8m3C9Qj1FuquSSu1MkSIL/sQs'
WHERE [Id] = 2;
SELECT @@ROWCOUNT;

GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20240621141645_InitialCreate', N'7.0.11');
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

UPDATE [Category] SET [CreatedAt] = '2024-06-21T21:28:20.2727964+07:00'
WHERE [Id] = 1;
SELECT @@ROWCOUNT;

GO

UPDATE [Category] SET [CreatedAt] = '2024-06-21T21:28:20.2727982+07:00'
WHERE [Id] = 2;
SELECT @@ROWCOUNT;

GO

UPDATE [Category] SET [CreatedAt] = '2024-06-21T21:28:20.2727984+07:00'
WHERE [Id] = 3;
SELECT @@ROWCOUNT;

GO

UPDATE [Category] SET [CreatedAt] = '2024-06-21T21:28:20.2727986+07:00'
WHERE [Id] = 4;
SELECT @@ROWCOUNT;

GO

UPDATE [Category] SET [CreatedAt] = '2024-06-21T21:28:20.2727988+07:00'
WHERE [Id] = 5;
SELECT @@ROWCOUNT;

GO

UPDATE [User] SET [CreatedAt] = '2024-06-21T21:28:20.2487538+07:00', [Password] = N'XJ+bFMgdqMFtAtugtxxEIB7lng78fb7PksgilwF3fzPWT6Eu'
WHERE [Id] = 1;
SELECT @@ROWCOUNT;

GO

UPDATE [User] SET [CreatedAt] = '2024-06-21T21:28:20.2576620+07:00', [Password] = N'ZqznGi7QLTcmeZd/FTmjop/yBNtnufXC8IK7+rmxJokIfNAJ'
WHERE [Id] = 2;
SELECT @@ROWCOUNT;

GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20240621142820_dbInit', N'7.0.11');
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

UPDATE [Category] SET [CreatedAt] = '2024-06-21T22:09:01.1699462+07:00'
WHERE [Id] = 1;
SELECT @@ROWCOUNT;

GO

UPDATE [Category] SET [CreatedAt] = '2024-06-21T22:09:01.1699478+07:00'
WHERE [Id] = 2;
SELECT @@ROWCOUNT;

GO

UPDATE [Category] SET [CreatedAt] = '2024-06-21T22:09:01.1699480+07:00'
WHERE [Id] = 3;
SELECT @@ROWCOUNT;

GO

UPDATE [Category] SET [CreatedAt] = '2024-06-21T22:09:01.1699482+07:00'
WHERE [Id] = 4;
SELECT @@ROWCOUNT;

GO

UPDATE [Category] SET [CreatedAt] = '2024-06-21T22:09:01.1699483+07:00'
WHERE [Id] = 5;
SELECT @@ROWCOUNT;

GO

UPDATE [User] SET [CreatedAt] = '2024-06-21T22:09:01.1513402+07:00', [Password] = N'csArawMS6TndwS24+90UiLLciEERn+zB2KoSeYaOFLbwSZSy'
WHERE [Id] = 1;
SELECT @@ROWCOUNT;

GO

UPDATE [User] SET [CreatedAt] = '2024-06-21T22:09:01.1571948+07:00', [Password] = N'QkvH9HOOYH1Wn892w+PPiPMJMQcUaFPQl7bOT0P6itOntCp1'
WHERE [Id] = 2;
SELECT @@ROWCOUNT;

GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20240621150901_Init', N'7.0.11');
GO

COMMIT;
GO

