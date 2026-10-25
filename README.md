# Nashville Housing – Data Cleaning in SQL

Cleaning a public Nashville housing sales dataset with T-SQL (Microsoft SQL Server).

## Files

- `SQL-DB CLeaning Query.sql` – all cleaning steps, in order.
- `Data Souce/Nashville Housing Data for Data Cleaning.xlsx` – the raw data.

## Steps

1. Convert `SaleDate` to a proper `DATE` type (three ways shown).
2. Fill missing property addresses from other rows with the same `ParcelID` (self-join).
3. Split `PropertyAddress` into address and city with `SUBSTRING` / `CHARINDEX`.
4. Split `OwnerAddress` into address, city and state with `PARSENAME`.
5. Change `Y` / `N` to `Yes` / `No` in `SoldAsVacant` with `CASE`.
6. Remove duplicate rows with `ROW_NUMBER() OVER (PARTITION BY …)`.
7. Drop columns that are no longer needed.

## How to run

1. Import the Excel file into SQL Server as table `NashvilleHousing` in a database named `Portfolio`.
2. Run the script step by step. Each step has a `SELECT` check before the `UPDATE`.

Note: the script changes the table in place, so keep a copy of the raw data.
