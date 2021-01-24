USE ElGiganto26
GO


-- procedure för få fram de 5 populäraste produkterna i en viss kategori
Create or Alter Procedure PopularityReport (@categoryID int)
AS
Begin
Select top 5 C.Category, P.ID, Brands.BrandName, P.ArticleID, P.Name, P.Popularity From Products AS P
Inner Join Brands ON Brands.ID = P.BrandID
Inner Join Product_Category AS PC ON PC.Product_ID = P.ID
Inner Join Categories AS C ON C.ID = PC.Category_ID
Where PC.Category_ID = @categoryID AND P.Popularity > 0
Order BY P.Popularity DESC
END
GO

-- procedure för de 5 mest returnerade produkterna, ej reklamationer
Create or Alter Procedure ReturnReport (@categoryID int)
AS
Begin
	Select TOP 5 C.Category, P.ID, Brands.BrandName, P.ArticleID, P.Name, SUM(OL.Returned) AS Returned From Products AS P
	Inner Join Brands ON Brands.ID = P.BrandID
	Inner Join OrderLines AS OL ON OL.ProductID = P.ID
	inner join Product_Category AS PC ON PC.Product_ID = P.ID
	Inner Join Categories AS C ON C.ID = PC.Category_ID
	Where OL.Returned > 0 AND PC.Category_ID = @categoryID
	Group BY P.ID, Brands.BrandName, P.ArticleID, P.Name, C.Category
	Order BY Returned DESC, P.ID
END
GO

