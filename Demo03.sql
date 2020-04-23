-- Step 1 

USE tempdb;
GO


-- Step 2 

CREATE PRIMARY XML INDEX IX_ProductImport_ProductDetails
ON dbo.ProductImport (ProductDetails);
GO


-- Step 3 


CREATE XML INDEX IX_ProductImport_ProductDetails_Value
ON dbo.ProductImport (ProductDetails)
USING XML INDEX IX_ProductImport_ProductDetails
FOR VALUE;
GO

-- Step 4 

SELECT * FROM sys.xml_indexes;
GO


-- Step 5 

DROP TABLE dbo.ProductImport;
GO

CREATE TABLE dbo.ProductImport
( ProductImportID int IDENTITY(1,1),
  ProductDetails xml (CONTENT dbo.ProductDetailsSchema)
);
GO

