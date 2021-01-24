Use ElGiganto26
GO

-- Se info om Produkten
Create Or Alter Procedure ViewProduct (@productID int)
AS
Begin
Update Products Set Popularity += 2
	Where ID = @productID
Select P.ID, Brands.BrandName, P.Name, P.Colour, P.Size, P.Price, P.Info, 
	Case
		When InStock >= 100 Then '100+ i Lager'
		When InStock >= 50 Then '50+ i Lager'
		When InStock >= 25 Then '25+ i Lager'
		When InStock >= 10 Then '10+ i Lager'
		When InStock >= 5 Then '5+ i Lager'
		when InStock < 5 Then 'Mindre än 5 i Lager'
		When InStock <= 0 Then 'Slut i Lager'
		Else ''
	END AS InStock
	From Products AS P
	Inner Join Brands ON Brands.ID = P.BrandID
	Where P.ID = @productID
END
GO

-- Procedure för att se alla produkter med samma artikelID
Create or Alter Procedure ViewArticle (@articleID varchar (10))
AS
Begin
	Select P.ID, Brands.BrandName, P.Name, P.ArticleID, P.Info, P.Size, P.Colour,
	Case
		When InStock >= 100 Then '100+ i Lager'
		When InStock >= 50 Then '50+ i Lager'
		When InStock >= 25 Then '25+ i Lager'
		When InStock >= 10 Then '10+ i Lager'
		When InStock >= 5 Then '5+ i Lager'
		when InStock < 5 Then 'Mindre än 5 i Lager'
		When InStock <= 0 Then 'Slut i Lager'
		Else ''
	END AS InStock
	From Products P
	Inner Join Brands on Brands.ID = P.BrandID
		Where P.ArticleID = @articleID
	Update Products Set Popularity += 1
		Where ArticleID LIKE @articleID
END
GO

-- Procedure för att få fram alla artiklar i en viss kategori
Create or Alter Procedure CategoryProductList (@categoryID int)
AS
Begin
	Select Brands.BrandName, Products.ArticleID, Products.Name, Products.Info, Products.Colour, Products.Price, SUM(Popularity) Popularity From Products
	Inner Join Product_Category on Product_Category.Product_ID = Products.ID
	Inner Join Brands on Brands.ID = Products.BrandID
	Where Product_Category.Category_ID = @categoryID AND Products.InStock > 0
	Group By Price, Colour, Info, Name, ArticleID, BrandName
	Order BY Popularity desc
END
GO
/*
--Procedure för att söka produkter
Create or Alter Procedure SearchProducts1 (
		@searchstring varchar(50) null,
		@instock bit,
		@orderby int)
AS
Begin
	-- Sortera på popularitet
	IF (@orderby = 1)
	Begin
		-- Visa alla produkter
		IF (@instock = 0)
		Begin
			Select Distinct P.ID, Brands.BrandName, P.ArticleID, P.Name, P.Price, P.Colour, P.Size, P.Popularity From Products P
			Inner Join Brands on Brands.ID = P.BrandID
			Where Brands.BrandName Like '%' + @searchstring + '%' OR P.ArticleID Like '%' + @searchstring + '%' OR P.Name LIKE '%' + @searchstring + '%' OR 
					P.Colour LIKE '%' + @searchstring + '%' OR P.Info LIKE '%' + @searchstring + '%'
			Order BY P.Popularity desc, P.ID
		END
		-- Visa bara produkter i lager
		IF (@instock = 1)
		Begin
			Select Distinct P.ID, Brands.BrandName, P.ArticleID, P.Name, P.Price, P.Colour, P.Size, P.Popularity From Products P
			Inner Join Brands on Brands.ID = P.BrandID
			Where (Brands.BrandName Like '%' + @searchstring + '%' OR P.ArticleID Like '%' + @searchstring + '%' OR P.Name LIKE '%' + @searchstring + '%' OR 
					P.Colour LIKE '%' + @searchstring + '%' OR P.Info LIKE '%' + @searchstring + '%' ) AND P.InStock > 0
			Order BY P.Popularity desc, P.ID
		END
	END
	-- Sortera på Pris
	IF (@orderby = 2)
	Begin
		-- Visa alla produkter
		IF (@instock = 0)
		Begin
			Select Distinct P.ID, Brands.BrandName, P.ArticleID, P.Name, P.Price, P.Colour, P.Size From Products P
			Inner Join Brands on Brands.ID = P.BrandID
			Where Brands.BrandName Like '%' + @searchstring + '%' OR P.ArticleID Like '%' + @searchstring + '%' OR P.Name LIKE '%' + @searchstring + '%' OR 
					P.Colour LIKE '%' + @searchstring + '%' OR P.Info LIKE '%' + @searchstring + '%'
			Order BY P.Price desc, P.ID
		END
		-- Visa bara produkter i lager
		IF (@instock = 1)
		Begin
			Select Distinct P.ID, Brands.BrandName, P.ArticleID, P.Name, P.Price, P.Colour, P.Size From Products P
			Inner Join Brands on Brands.ID = P.BrandID
			Where (Brands.BrandName Like '%' + @searchstring + '%' OR P.ArticleID Like '%' + @searchstring + '%' OR P.Name LIKE '%' + @searchstring + '%' OR 
					P.Colour LIKE '%' + @searchstring + '%' OR P.Info LIKE '%' + @searchstring + '%')
					AND P.InStock > 0
			Order BY P.Price desc, P.ID
		END
	END
	-- Sortera på Namn
	IF (@orderby = 3)
	Begin
		-- Visa alla produkter
		IF (@instock = 0)
		Begin
			Select Distinct P.ID, Brands.BrandName, P.ArticleID, P.Name, P.Price, P.Colour, P.Size From Products P
			Inner Join Brands on Brands.ID = P.BrandID
			Where Brands.BrandName Like '%' + @searchstring + '%' OR P.ArticleID Like '%' + @searchstring + '%' OR P.Name LIKE '%' + @searchstring + '%' OR 
					P.Colour LIKE '%' + @searchstring + '%' OR P.Info LIKE '%' + @searchstring + '%'
			Order BY P.Name, P.ID
		END
		-- Visa bara produkter i lager
		IF (@instock = 1)
		Begin
			Select Distinct P.ID, Brands.BrandName, P.ArticleID, P.Name, P.Price, P.Colour, P.Size From Products P
			Inner Join Brands on Brands.ID = P.BrandID
			Where (Brands.BrandName Like '%' + @searchstring + '%' OR P.ArticleID Like '%' + @searchstring + '%' OR P.Name LIKE '%' + @searchstring + '%' OR 
					P.Colour LIKE '%' + @searchstring + '%' OR P.Info LIKE '%' + @searchstring + '%')
					AND P.InStock > 0
			Order BY P.Name, P.ID
		END
	END
END
GO
*/


Create or Alter Procedure SearchProducts2 ( -- Sökprocedure #2
		@searchstring varchar(50) null,
		@instock bit,
		@orderby int) -- 1 = popularitet, 2 = pris, 3 = namn 
AS
Begin
	-- Visar bara produkter i lager
	IF (@instock = 1)
	Begin
		Select P.ID, Brands.BrandName, P.ArticleID, P.Name, P.Price, P.Colour, P.Size, P.Popularity From Products P
		Inner Join Brands on Brands.ID = P.BrandID
		Where 		
			(Brands.BrandName Like '%' + @searchstring + '%' OR P.ArticleID Like '%' + @searchstring + '%' OR P.Name LIKE '%' + @searchstring + '%' OR 
			P.Colour LIKE '%' + @searchstring + '%' OR P.Info LIKE '%' + @searchstring + '%') AND P.InStock > 0		
		Order BY 
			(Case When @orderby = 1 then P.Popularity end) desc,
			(Case When @orderby = 2 then P.Price end) desc,
			(Case When @orderby = 3 then P.Name end),
			P.ID
	END
	-- Visar all produkter
	IF(@instock = 0)
	Begin
		Select P.ID, Brands.BrandName, P.ArticleID, P.Name, P.Price, P.Colour, P.Size, P.Popularity From Products P
		Inner Join Brands on Brands.ID = P.BrandID
		Where 		
			(Brands.BrandName Like '%' + @searchstring + '%' OR P.ArticleID Like '%' + @searchstring + '%' OR P.Name LIKE '%' + @searchstring + '%' OR 
			P.Colour LIKE '%' + @searchstring + '%' OR P.Info LIKE '%' + @searchstring + '%')	
		Order BY 
			(Case When @orderby = 1 then P.Popularity end) desc,
			(Case When @orderby = 2 then P.Price end) desc,
			(Case When @orderby = 3 then P.Name end),
			P.ID
	END
END
GO

