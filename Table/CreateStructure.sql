/*
Схема dbo существует в БД по умолчанию, поэтому ее наличие в БД не проверяем.
Создаем таблицу dbo.SKU, если она не существует
*/
if object_id('dbo.SKU') is null
begin
	create table dbo.SKU (
		ID int not null identity,
		Code as concat('s', cast(ID as varchar(254))),
		Name varchar(255) not null,
		MDT_ID_PrincipalCreatedBy int not null,
		MDT_DateCreate datetime not null,
		constraint PK_SKU primary key clustered (ID)
	)
	alter table dbo.SKU add constraint UK_SKU_Code unique(Code)
	alter table dbo.SKU add constraint DF_SKU_MDT_ID_PrincipalCreatedBy default mdt.ID_User() for MDT_ID_PrincipalCreatedBy
    alter table dbo.SKU add constraint FK_SKU_MDT_ID_PrincipalCreatedBy_Principal foreign key (MDT_ID_PrincipalCreatedBy) references mdt.Principal(ID)
    alter table dbo.SKU add constraint DF_SKU_MDT_DateCreate default getdate() for MDT_DateCreate
end

-- Создаем таблицу dbo.Family, если она не существует
if object_id('dbo.Family') is null
begin
	create table dbo.Family (
		ID int not null identity,
		SurName varchar(255) not null,
		BudgetValue decimal(18, 2) not null,
		MDT_ID_PrincipalCreatedBy int not null,
		MDT_DateCreate datetime not null,
		constraint PK_Family primary key clustered (ID)
	)
	alter table dbo.Family add constraint DF_Family_MDT_ID_PrincipalCreatedBy default mdt.ID_User() for MDT_ID_PrincipalCreatedBy
    alter table dbo.Family add constraint FK_Family_MDT_ID_PrincipalCreatedBy_Principal foreign key (MDT_ID_PrincipalCreatedBy) references mdt.Principal(ID)
    alter table dbo.Family add constraint DF_Family_MDT_DateCreate default getdate() for MDT_DateCreate
end

-- Создаем таблицу dbo.Basket, если она не существует
if object_id('dbo.Basket') is null
begin
	create table dbo.Basket (
		ID int not null identity,
		ID_SKU int not null,
		ID_Family int not null,
		Quantity int not null,
		[Value] decimal(18, 2) not null,
		-- Наименование поля приведено как в задании, но по кодстайлу должно быть DatePurchase
		PurchaseDate date not null,
		DiscountValue decimal(18, 2),
		MDT_ID_PrincipalCreatedBy int not null,
		MDT_DateCreate datetime not null,
		constraint PK_Basket primary key clustered (ID)
	)
	alter table dbo.Basket add constraint FK_Basket_ID_SKU_SKU foreign key (ID_SKU) references dbo.SKU(ID)
	alter table dbo.Basket add constraint FK_Basket_ID_Family_Family foreign key (ID_Family) references dbo.Family(ID)
	alter table dbo.Basket add constraint DF_Basket_PurchaseDate default getdate() for PurchaseDate
	alter table dbo.Basket add constraint DF_Basket_MDT_ID_PrincipalCreatedBy default mdt.ID_User() for MDT_ID_PrincipalCreatedBy
	alter table dbo.Basket add constraint FK_Basket_MDT_ID_PrincipalCreatedBy_Principal foreign key (MDT_ID_PrincipalCreatedBy) references mdt.Principal(ID)
	alter table dbo.Basket add constraint DF_Basket_MDT_DateCreate default getdate() for MDT_DateCreate
	alter table dbo.Basket add constraint CK_Basket_Quantity_Value check (
		Quantity > 0 
			and [Value] > 0
	)
end