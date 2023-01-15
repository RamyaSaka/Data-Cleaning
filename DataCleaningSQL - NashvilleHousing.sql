-- Data Cleaning using SQL Queries


Select * from PortfolioProject..NashvilleHousing


--Standardizing date format

ALTER TABLE NashvilleHousing 
ADD SaleDateConverted Date;

update NashvilleHousing
set SaleDateConverted = CONVERT(DATE, SaleDate)

Select SaleDateConverted, CONVERT(DATE, SaleDate)
from PortfolioProject..NashvilleHousing


--populate property address data

Select * from PortfolioProject..NashvilleHousing 
order by parcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject..NashvilleHousing a
join PortfolioProject..NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


update a
set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject..NashvilleHousing a
join PortfolioProject..NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


--BREAKING OUT ADDRESS INTO INDIVIDUAL COLUMNS (ADDRESS, CITY, STATE)

Select PropertyAddress from PortfolioProject..NashvilleHousing 

SELECT substring(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1) as address,
SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress)) as ADDRESS
FROM PortfolioProject..NashvilleHousing

ALTER TABLE NashvilleHousing 
ADD PropertySplitAddress NVARCHAR(255);

update NashvilleHousing
set PropertySplitAddress = substring(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1)

ALTER TABLE NashvilleHousing 
ADD PropertySplitCity NVARCHAR(255);

update NashvilleHousing
set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress))

select * from PortfolioProject..NashvilleHousing



select OwnerAddress from PortfolioProject..NashvilleHousing

select 
PARSENAME(REPLACE(OwnerAddress, ',', '.'),3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'),2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)
from PortfolioProject..NashvilleHousing

ALTER TABLE NashvilleHousing 
ADD OwnerSplitAddress NVARCHAR(255);

update NashvilleHousing
set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)

ALTER TABLE NashvilleHousing 
ADD OwnerSplitCity NVARCHAR(255);

update NashvilleHousing
set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)

ALTER TABLE NashvilleHousing 
ADD OwnerSplitState NVARCHAR(255);

update NashvilleHousing
set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)

select * from PortfolioProject..NashvilleHousing



--Change Y and N to Yes and No in Sold as Vacant field

select DISTINCT(SoldAsVacant), count(SoldAsVacant)
from PortfolioProject..NashvilleHousing
group by SoldAsVacant
order by 2

Select SoldAsVacant, 
CASE when SoldAsVacant = 'Y' then 'Yes'
when SoldAsVacant = 'N' then 'No'
ELSE SoldAsVacant
END
FROM PortfolioProject..NashvilleHousing

update NashvilleHousing
set SoldAsVacant = CASE when SoldAsVacant = 'Y' then 'Yes'
when SoldAsVacant = 'N' then 'No'
ELSE SoldAsVacant
END


--Remove Duplicates

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

From PortfolioProject.dbo.NashvilleHousing
--order by ParcelID
)




select * from RowNumCTE
where row_num >1 
order by PropertyAddress


--Delete unused columns

select * from PortfolioProject..NashvilleHousing

ALTER TABLE PortfolioProject..NashvilleHousing
drop column owneraddress, taxdistrict, propertyaddress, saledate