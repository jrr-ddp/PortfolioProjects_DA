/*
Cleaning Data Using Sql Queries
*/

SELECT *
FROM PortfolioProject_DA.dbo.NashvilleHousing


------Change the Data Format

-- Type-1 Directly Alter the column(Direct Way)

ALTER TABLE PortfolioProject_DA.dbo.NashvilleHousing
ALTER COLUMN SaleDate Date

SELECT SaleDate
FROM PortfolioProject_DA.dbo.NashvilleHousing

--Type-2

--SELECT SaleDate, CONVERT(Date,SaleDate) As SalesDate
--FROM PortfolioProject_DA.dbo.NashvilleHousing

--UPDATE PortfolioProject_DA.dbo.NashvilleHousing
--SET SaleDate = CONVERT(Date, SaleDate)

--ALTER TABLE PortfolioProject_DA.dbo.NashvilleHousing
--ADD SaleDateConverted Date;

--UPDATE PortfolioProject_DA.dbo.NashvilleHousing
--SET SaleDateConverted = CONVERT(date,SaleDate)



------Property Address Data

SELECT *
FROM PortfolioProject_DA.dbo.NashvilleHousing
WHERE PropertyAddress IS NULL

SELECT PropertyAddress
FROM PortfolioProject_DA.dbo.NashvilleHousing
WHERE PropertyAddress IS NULL

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress) AS Sample
FROM PortfolioProject_DA.dbo.NashvilleHousing a
JOIN PortfolioProject_DA.dbo.NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM PortfolioProject_DA.dbo.NashvilleHousing a
JOIN PortfolioProject_DA.dbo.NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL



------Breaking Out Address Into Different Columns(Address, City, State)

--Property Address

SELECT *
FROM PortfolioProject_DA.dbo.NashvilleHousing

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress)) As Address
FROM PortfolioProject_DA.dbo.NashvilleHousing


UPDATE PortfolioProject_DA.dbo.NashvilleHousing
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress)) As Address
FROM PortfolioProject_DA.dbo.NashvilleHousing


--ALTER TABLE PortfolioProject_DA.dbo.NashvilleHousing
--ADD PropertySplitAddress Nvarchar(255) SET Address = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1),
--PropertySplitCity Nvarchar(255) SET City = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress))

ALTER TABLE PortfolioProject_DA.dbo.NashvilleHousing
Add PropertyAddress1 Nvarchar(225);

UPDATE PortfolioProject_DA.dbo.NashvilleHousing
SET PropertyAddress1 = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE PortfolioProject_DA.dbo.NashvilleHousing
Add PropertyCity Nvarchar(225);

UPDATE PortfolioProject_DA.dbo.NashvilleHousing
SET PropertyCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress))


--Owner Address

SELECT *
FROM PortfolioProject_DA.dbo.NashvilleHousing

SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.'),3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'),2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)
FROM PortfolioProject_DA.dbo.NashvilleHousing

ALTER TABLE PortfolioProject_DA.dbo.NashvilleHousing
Add OwnerAddress1 Nvarchar(225);

UPDATE PortfolioProject_DA.dbo.NashvilleHousing
SET OwnerAddress1 = PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)

ALTER TABLE PortfolioProject_DA.dbo.NashvilleHousing
Add OwnerCity Nvarchar(225);

UPDATE PortfolioProject_DA.dbo.NashvilleHousing
SET OwnerCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)

ALTER TABLE PortfolioProject_DA.dbo.NashvilleHousing
Add OwnerState Nvarchar(225);

UPDATE PortfolioProject_DA.dbo.NashvilleHousing
SET OwnerState = PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)



------Change Y ad N to Yes and No in "Sold as Vacant" Field

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM PortfolioProject_DA.dbo.NashvilleHousing
GROUP BY SoldAsVacant
w