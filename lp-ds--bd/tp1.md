# Langage SQL

## Modèle des données

Nous avons les données (au format CSV) correspondant à un data-mart centré sur les ventes Internet d'une entreprise. Voici le MRD obtenu (il est possible de zoomer pour mieux voir le schéma) :

<iframe width="560" height="315" src='https://dbdiagram.io/embed/617974a7fa17df5ea671e8d8'> </iframe>

Et vous trouverez ci-dessous le code SQL **incomplet** permettant la création des tables. Les données au format CSV sont disponibles dans le répertoire commun `H:\COMMUN\Licence Pro DATA MINING\2021-2022\BD\ADVWORKS`. 

## Demande

Vous devez réaliser les étapes suivantes :

1. Modifier le script de création des tables pour intégrer les contraintes de clés primaires et de clés externes ;
2. Importer les données dans SAS et les intégrer dans les tables 
  - A faire en 2 étapes :
    1. Importer les données d'un fichier dans une table temporaire
    2. Les insérer dans la table de destination, à l'aide de la commande `INSERT INTO` :
```
INSERT INTO TABLE_DESTINATION (liste des champs)
   SELECT ... FROM TABLE_SOURCE;
```
3. Répondre aux demandes suivantes :
  - Compter le nombre de clients 
  - Compter le nombre de pays d'origine des clients
  - Donner par catégorie, le nombre de produits et le nombre de sous-catégories
  - Donner les 10 produits les plus vendus
  - Calculer le montant total du CA
  - Donner les 10 clients ayant le CA le plus élevé
  - Calculer le CA par année (en considérant la date de commande)
  - Idem, mais par mois
  - Idem, mais par jour de la semaine
  - Idem, mais par jour sur toute la période


## Script SQL de création des tables

```
CREATE TABLE DimCurrency(
	CurrencyKey int PRIMARY KEY NOT NULL,
	CurrencyAlternateKey char(3) NOT NULL,
	CurrencyName varchar(50) NOT NULL
);

CREATE TABLE DimCustomer(
	CustomerKey int PRIMARY KEY NOT NULL,
	GeographyKey int,
	CustomerAlternateKey varchar(15) NOT NULL,
	Title varchar(8),
	FirstName varchar(50),
	MiddleName varchar(50),
	LastName varchar(50),
	NameStyle smallint,
	BirthDate  date,
	MaritalStatus char(1),
	Suffix varchar(10),
	Gender varchar(1),
	EmailAddress varchar(50),
	YearlyIncome int,
	TotalChildren smallint,
	NumberChildrenAtHome smallint,
	EnglishEducation varchar(40),
	SpanishEducation varchar(40),
	FrenchEducation varchar(40),
	EnglishOccupation varchar(100),
	SpanishOccupation varchar(100),
	FrenchOccupation varchar(100),
	HouseOwnerFlag char(1),
	NumberCarsOwned smallint,
	AddressLine1 varchar(120),
	AddressLine2 varchar(120),
	Phone varchar(20),
	DateFirstPurchase  date,
	CommuteDistance varchar(15)
);

CREATE TABLE DimDate(
	DateKey int NOT NULL,
	FullDateAlternateKey date NOT NULL,
	DayNumberOfWeek smallint NOT NULL,
	EnglishDayNameOfWeek varchar(10) NOT NULL,
	SpanishDayNameOfWeek varchar(10) NOT NULL,
	FrenchDayNameOfWeek varchar(10) NOT NULL,
	DayNumberOfMonth smallint NOT NULL,
	DayNumberOfYear smallint NOT NULL,
	WeekNumberOfYear smallint NOT NULL,
	EnglishMonthName varchar(10) NOT NULL,
	SpanishMonthName varchar(10) NOT NULL,
	FrenchMonthName varchar(10) NOT NULL,
	MonthNumberOfYear smallint NOT NULL,
	CalendarQuarter smallint NOT NULL,
	CalendarYear smallint NOT NULL,
	CalendarSemester smallint NOT NULL,
	FiscalQuarter smallint NOT NULL,
	FiscalYear smallint NOT NULL,
	FiscalSemester smallint NOT NULL
);

CREATE TABLE DimGeography(
	GeographyKey int PRIMARY KEY NOT NULL,
	City varchar(30),
	StateProvinceCode varchar(3),
	StateProvinceName varchar(50),
	CountryRegionCode varchar(3),
	EnglishCountryRegionName varchar(50),
	SpanishCountryRegionName varchar(50),
	FrenchCountryRegionName varchar(50),
	PostalCode varchar(15),
	SalesTerritoryKey int,
	IpAddressLocator varchar(15)
);

CREATE TABLE DimProduct(
	ProductKey int PRIMARY KEY NOT NULL,
	ProductAlternateKey varchar(25),
	ProductSubcategoryKey int,
	WeightUnitMeasureCode char(3),
	SizeUnitMeasureCode char(3),
	EnglishProductName varchar(50) NOT NULL,
	SpanishProductName varchar(50) NOT NULL,
	FrenchProductName varchar(50) NOT NULL,
	StandardCost numeric,
	FinishedGoodsFlag int NOT NULL,
	Color varchar(15) NOT NULL,
	SafetyStockLevel smallint,
	ReorderPoint smallint,
	ListPrice numeric,
	Size varchar(50),
	SizeRange varchar(50),
	Weight float,
	DaysToManufacture int,
	ProductLine char(2),
	DealerPrice numeric,
	Class char(2),
	Style char(2),
	ModelName varchar(50),
	LargePhoto varchar(100000),
	EnglishDescription varchar(400),
	FrenchDescription varchar(400),
	ChineseDescription varchar(400),
	ArabicDescription varchar(400),
	HebrewDescription varchar(400),
	ThaiDescription varchar(400),
	GermanDescription varchar(400),
	JapaneseDescription varchar(400),
	TurkishDescription varchar(400),
	StartDate date,
	EndDate date,
	Status varchar(7)
);

CREATE TABLE DimProductCategory(
	ProductCategoryKey int PRIMARY KEY NOT NULL,
	ProductCategoryAlternateKey int,
	EnglishProductCategoryName varchar(50) NOT NULL,
	SpanishProductCategoryName varchar(50) NOT NULL,
	FrenchProductCategoryName varchar(50) NOT NULL
);

CREATE TABLE DimProductSubcategory(
	ProductSubcategoryKey int PRIMARY KEY NOT NULL,
	ProductSubcategoryAlternateKey int,
	EnglishProductSubcategoryName varchar(50) NOT NULL,
	SpanishProductSubcategoryName varchar(50) NOT NULL,
	FrenchProductSubcategoryName varchar(50) NOT NULL,
	ProductCategoryKey int 
);

CREATE TABLE DimPromotion(
	PromotionKey int PRIMARY KEY NOT NULL,
	PromotionAlternateKey int,
	EnglishPromotionName varchar(255),
	SpanishPromotionName varchar(255),
	FrenchPromotionName varchar(255),
	DiscountPct float,
	EnglishPromotionType varchar(50),
	SpanishPromotionType varchar(50),
	FrenchPromotionType varchar(50),
	EnglishPromotionCategory varchar(50),
	SpanishPromotionCategory varchar(50),
	FrenchPromotionCategory varchar(50),
	StartDate date,
	EndDate date,
	MinQty int,
	MaxQty int
);


CREATE TABLE DimSalesTerritory(
	SalesTerritoryKey int PRIMARY KEY NOT NULL,
	SalesTerritoryAlternateKey int,
	SalesTerritoryRegion varchar(50) NOT NULL,
	SalesTerritoryCountry varchar(50) NOT NULL,
	SalesTerritoryGroup varchar(50),
	SalesTerritoryImage varchar(100000)
);

CREATE TABLE FactInternetSales(
	ProductKey int NOT NULL,
	OrderDateKey int NOT NULL,
	DueDateKey int NOT NULL,
	ShipDateKey int NOT NULL,
	CustomerKey int NOT NULL,
	PromotionKey int NOT NULL,
	CurrencyKey int NOT NULL,
	SalesTerritoryKey int NOT NULL,
	SalesOrderNumber varchar(20) NOT NULL,
	SalesOrderLineNumber smallint NOT NULL,
	RevisionNumber smallint NOT NULL,
	OrderQuantity smallint NOT NULL,
	UnitPrice numeric NOT NULL,
	ExtendedAmount numeric NOT NULL,
	UnitPriceDiscountPct float NOT NULL,
	DiscountAmount float NOT NULL,
	ProductStandardCost numeric NOT NULL,
	TotalProductCost numeric NOT NULL,
	SalesAmount numeric NOT NULL,
	TaxAmt numeric NOT NULL,
	Freight numeric NOT NULL,
	CarrierTrackingNumber varchar(25),
	CustomerPONumber varchar(25),
	OrderDate date,
	DueDate date,
	ShipDate date
);
```
