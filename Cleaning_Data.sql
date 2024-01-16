/*

Cleaning Data in SQL Queries

*/


Select *
From PortafolioProject.dbo.NashvilleHousing



--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format


Select SaleDateConverted, convert(date, saledate)
From PortafolioProject.dbo.NashvilleHousing


Update PortafolioProject.dbo.NashvilleHousing
set saledate= convert(date, saledate)

-- If it doesn't Update properly

ALTER TABLE PortafolioProject.dbo.NashvilleHousing
Add SaleDateConverted Date;

Update PortafolioProject.dbo.NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)

 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data


Select PropertyAddress
From PortafolioProject.dbo.NashvilleHousing
where PropertyAddress is null


select a.ParcelID, a.PropertyAddress, b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortafolioProject.dbo.NashvilleHousing a
join PortafolioProject.dbo.NashvilleHousing b
	on a.ParcelID=b.ParcelID
		and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortafolioProject.dbo.NashvilleHousing a
join PortafolioProject.dbo.NashvilleHousing b
	on a.ParcelID=b.ParcelID
		and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null


--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)

Select PropertyAddress
From PortafolioProject.dbo.NashvilleHousing
--where PropertyAddress is null
--order by ParcelID

select
SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) as Address

from PortafolioProject.dbo.NashvilleHousing


ALTER TABLE PortafolioProject.dbo.NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update PortafolioProject.dbo.NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress)-1) 


ALTER TABLE PortafolioProject.dbo.NashvilleHousing
Add PropertySplitCity Nvarchar(255);
Update PortafolioProject.dbo.NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))


Select *
From PortafolioProject.dbo.NashvilleHousing



select OwnerAddress
from PortafolioProject.dbo.NashvilleHousing

select
PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
from PortafolioProject.dbo.NashvilleHousing

ALTER TABLE PortafolioProject.dbo.NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update PortafolioProject.dbo.NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE PortafolioProject.dbo.NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update PortafolioProject.dbo.NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE PortafolioProject.dbo.NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update PortafolioProject.dbo.NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From PortafolioProject.dbo.NashvilleHousing

--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field

select DistInct(SoldAsVacant), Count(SoldAsVacant)
from PortafolioProject.dbo.NashvilleHousing
group by SoldAsVacant
order by 2

Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From PortafolioProject.dbo.NashvilleHousing

Update PortafolioProject.dbo.NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END


	   -----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From PortafolioProject.dbo.NashvilleHousing
--order by ParcelID
)
Select*
From RowNumCTE
Where row_num > 1
--Order by PropertyAddress


---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns



Select *
From PortafolioProject.dbo.NashvilleHousing

ALTER TABLE PortafolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

