/*
Data Cleaning in SQL
*/

SELECT * FROM NashvilleHousing

--Standardize date format

SELECT SaleDate, CONVERT(Date,SaleDate) AS NewDate
FROM NashvilleHousing

-- Not Working use ALTER TABLE
UPDATE NashvilleHousing
SET Saledate = CONVERT(date,SaleDate)

ALTER TABLE NashvilleHousing
ADD SaleDateConverted Date

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(date,SaleDate)

------------------------------------------------------
-- Property address data

SELECT Propertyaddress
FROM NashvilleHousing
WHERE PropertyAddress IS NULL

-- 1st way
SELECT A.[UniqueID ],A.ParcelID, B.[UniqueID ],B.ParcelID
FROM NashvilleHousing A
JOIN NashvilleHousing B
	ON A.ParcelID = B.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]

-- 2nd way
SELECT A.[UniqueID ],A.propertyAddress,A.ParcelID, B.[UniqueID ],B.ParcelID,ISNULL(A.propertyAddress,B.propertyAddress)
FROM NashvilleHousing A, NashvilleHousing B
WHERE A.[UniqueID ] <> B.[UniqueID ]
AND A.ParcelID = B.ParcelID

UPDATE A
SET PropertyAddress = ISNULL(A.propertyAddress,B.propertyAddress)
FROM NashvilleHousing A
JOIN NashvilleHousing B
ON A.ParcelID = B.ParcelID
AND A.[UniqueID ] <> B.[UniqueID ]
WHERE A.propertyAddress IS NULL

SELECT * 
FROM NashvilleHousing

-- Breaking out address

SELECT PropertyAddress
FROM NashvilleHousing

SELECT SUBSTRING(PropertyAddress, 1,CHARINDEX(',',PropertyAddress)-1) AS Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) AS Address
FROM NashvilleHousing

ALTER TABLE NashvilleHousing
ADD PropertySplitAddress NVARCHAR(100)

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1,CHARINDEX(',',PropertyAddress)-1)

ALTER TABLE NashvilleHousing
ADD PropertySplitCity NVARCHAR(100)

UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))

----------------------------
-- Split the ownerAddress

SELECT 
PARSENAME(REPLACE(OwnerAddress,',','.'),1),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),3)
OwnerAddress
FROM NashvilleHousing

ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress NVARCHAR(100)

UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),1)

ALTER TABLE NashvilleHousing
ADD OwnerSplitCity NVARCHAR(100)

UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

ALTER TABLE NashvilleHousing
ADD OwnerSplitState NVARCHAR(100)

UPDATE NashvilleHousing
SET OwnerSplitState= PARSENAME(REPLACE(OwnerAddress,',','.'),3)


----------------------------------
-- Change Y and N to Yes And No

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM NashvilleHousing
GROUP BY SoldAsVacant

SELECT SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
FROM NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END


-- Remove Duplicates
WITH RowNumCTE AS(
SELECT *, 
ROW_NUMBER() OVER(
PARTITION BY ParcelID,
			 PropertyAddress,
			 SalePrice,
			 SaleDate,
			 LegalReference
			 ORDER BY 
				UniqueID) row_num

FROM NashvilleHousing
)

/* SELECT *
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress
*/

DELETE 
FROM RowNumCTE
WHERE row_num > 1

----------------------------------------
-- Delete unused Columns

ALTER TABLE NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE NashvilleHousing
DROP COLUMN Saledate

SELECT * FROM NashvilleHousing
