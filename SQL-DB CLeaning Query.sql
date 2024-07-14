/*

Cleaning Data Using SQL Queries

*/


Select *
From Portfolio..NashvilleHousing


----------------------------------------------------


-- Standardize Data Format

Select SaleDate, CONVERT(Date,SaleDate)
From Portfolio..NashvilleHousing


-- Update The Column
Update NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)


-- Update The Column (Second Way)
ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)

Select SaleDateConverted, CONVERT(Date,SaleDate)
From Portfolio..NashvilleHousing


-- Update The Column (Third Way)
ALTER TABLE NashvilleHousing
ALTER COLUMN SaleDate Date;


----------------------------------------------------------

-- Popualte Property Address Data


-- Check
Select PropertyAddress
From Portfolio..NashvilleHousing
Where PropertyAddress is null
order BY ParcelID


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From Portfolio..NashvilleHousing a
JOIN Portfolio..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


-- Update The (NULL) Rows in PropertyAddress

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From Portfolio..NashvilleHousing a
JOIN Portfolio..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


------------------------------------------------------------------------------

-- Beaking Out Address into Individual Columns (Address, City, State)


-- Check
Select PropertyAddress
From Portfolio..NashvilleHousing


-- Taking The Full address then Spilt Into Address - City

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address
From Portfolio..NashvilleHousing



-- Create New Columns to Hold the New Result (Address, City)

ALTER TABLE NashvilleHousing
ADD PropertySpiltAddress Nvarchar(255);


UPDATE NashvilleHousing
SET PropertySpiltAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)


ALTER TABLE NashvilleHousing
ADD PropertySpiltCity Nvarchar(255);


UPDATE NashvilleHousing
SET PropertySpiltCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))


-- Check
Select *
From Portfolio..NashvilleHousing


------------------------------------------------------------------------

-- Beaking Out "OwnerAddress" using (PARSENAME) instead of (SUBSTRING)


--Cheak
Select OwnerAddress
FROM Portfolio..NashvilleHousing


-- Taking The Full Owner Address then Spilt Into Address - City - State

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM Portfolio..NashvilleHousing


-- Create The New Columns

ALTER TABLE NashvilleHousing
ADD OwnerSpiltAddress Nvarchar(255);

ALTER TABLE NashvilleHousing
ADD OwnerSpiltCity Nvarchar(255);

ALTER TABLE NashvilleHousing
ADD OwnerSpiltState Nvarchar(255);


-- Update These Columns

UPDATE NashvilleHousing
SET OwnerSpiltAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)


UPDATE NashvilleHousing
SET OwnerSpiltCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)


UPDATE NashvilleHousing
SET OwnerSpiltState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)


-- Check
Select *
From Portfolio..NashvilleHousing


---------------------------------------------------------------------------------

-- Change Y and N to (Yes/No) in "SoldAsVacant" Field


-- Check

Select Distinct(SoldAsVacant), COUNT(SoldAsVacant)
From Portfolio..NashvilleHousing
Group BY SoldAsVacant
order by 2


-- Change"SoldAsVacant" using CASE Statement

Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' Then 'Yes'
	   When SoldAsVacant = 'N' Then 'No'
	   ELSE SoldAsVacant
	   END
From Portfolio..NashvilleHousing


-- Update "SoldAsVacant" With new Result

UPDATE NashvilleHousing
SET SoldAsVacant =  CASE When SoldAsVacant = 'Y' Then 'Yes'
	   When SoldAsVacant = 'N' Then 'No'
	   ELSE SoldAsVacant
	   END
From Portfolio..NashvilleHousing


------------------------------------------------------------------------


-- Remove Duplicates


/* In General We Dont Delete The Date from Database,
in most cases we Transfer the data into TempDb or CTE
*/


WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num
From Portfolio..NashvilleHousing
)
DELETE
FROM RowNumCTE
WHERE row_num > 1
--Order by PropertyAddress


------------------------------------------------------------------

-- Delete Unused Columns


Select *
From Portfolio..NashvilleHousing


ALTER TABLE Portfolio..NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE Portfolio..NashvilleHousing
DROP COLUMN SaleDate