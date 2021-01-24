Use ElGiganto26
GO
-- View för att få fram alla kategorier där det finns artiklar
Create or Alter View CategoryList
AS
	Select distinct Categories.ID, Categories.Category From Categories
	inner Join Product_Category on Product_Category.Category_ID = Categories.ID

GO
