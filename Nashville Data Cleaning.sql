SELECT *
FROM dbo.nash_hs;

-- Exploring Property Address Data
SELECT * 
FROM dbo.nash_hs
--WHERE PropertyAddress IS NULL
ORDER BY ParcelID;

-- Rows with the same ParcelID should have the same address
SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM dbo.nash_hs a
JOIN dbo.nash_hs b 
    ON a.ParcelID = b.ParcelID
    AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress IS NULL;


-- Updating the Null values using ISNULL
Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM dbo.nash_hs a
JOIN dbo.nash_hs b 
    ON a.ParcelID = b.ParcelID
    AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress IS NULL;

-- Splitting the city from PropertyAddress
SELECT PropertyAddress
FROM dbo.nash_hs;

--Using Substring, Charindex and LEN to Split by "," / Added +1 and -1 to remove commas from the final value
SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) AS Address
, SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1 ,LEN(PropertyAddress)) AS Address
FROM dbo.nash_hs

-- Adding the Split up data into new columns
ALTER TABLE dbo.nash_hs
add PropertySplitAddress Nvarchar(MAX);

Update dbo.nash_hs
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1);

ALTER TABLE dbo.nash_hs
add PropertySplitCity Nvarchar(MAX);

Update dbo.nash_hs
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1 ,LEN(PropertyAddress));

-- Splitting OwnerAdrress Using PARSENAME

SELECT OwnerAddress
FROM dbo.nash_hs;

--Changing "," to "." since PARSENAME only works with periods, not commas
SELECT PARSENAME(REPLACE(OwnerAddress,',','.'),3)
, PARSENAME(REPLACE(OwnerAddress,',','.'),2)
, PARSENAME(REPLACE(OwnerAddress,',','.'),1)
FROM dbo.nash_hs

--Creating and Updating New Columnns
ALTER TABLE dbo.nash_hs
add OwnerSplitAddress Nvarchar(MAX);

ALTER TABLE dbo.nash_hs
add OwnerSplitCity Nvarchar(MAX);

ALTER TABLE dbo.nash_hs
add OwnerSplitState Nvarchar(MAX);


Update dbo.nash_hs
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3);

Update dbo.nash_hs
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2);

Update dbo.nash_hs
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1);

-- Exploring SoldAVacant Column

SELECT DISTINCT SoldAsVacant, COUNT(SoldAsVacant)
FROM dbo.nash_hs
GROUP BY SoldAsVacant
ORDER BY 2;

-- Changing Y and N to Yes and No
SELECT SoldAsVacant
, CASE WHEN SoldAsVacant = 'Y' THEN 'YES'
        WHEN SoldAsVacant = 'N' THEN 'NO'
        ELSE SoldAsVacant
        END
FROM dbo.nash_hs;

UPDATE dbo.nash_hs
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'YES'
        WHEN SoldAsVacant = 'N' THEN 'NO'
        ELSE SoldAsVacant
        END
FROM dbo.nash_hs;

--Removing Duplicates
WITH RowNumCTE AS(
SELECT *,
    ROW_NUMBER() OVER (
        PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference ORDER BY UniqueID 
    ) row_num
FROM dbo.nash_hs)
DELETE 
FROM RowNumCTE
WHERE row_num > 1;

--Deleting Unsused Columns, OwnerAddress and PropertyAddress

ALTER TABLE dbo.nash_hs
DROP COLUMN OwnerAddress, PropertyAddress;

