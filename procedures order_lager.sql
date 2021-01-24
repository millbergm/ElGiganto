use ElGiganto26
GO

-- procedure för lagertransaktion, ej retur/reklamation
Create or Alter Procedure dbo.Stock_Transaction (@productID int, @markID int, @quantity int)
AS
Begin
--InLeverans ID 1 eller justering ID 5
	IF (@markID = 1 or @markID = 5)
	Begin
		Insert Into StockTransaction (ProductID, MarkID, Quantity)
			Values (@productID, @markID, @quantity)
		Update Products Set InStock += @quantity
			Where ID = @productID
	END
-- Utleverans ID 2
	IF (@markID = 2)
	Begin
		Insert Into StockTransaction (ProductID, MarkID, Quantity)
			Values (@productID, @markID, @quantity)
		Update Products Set InStock -= @quantity
			Where ID = @productID
	END
END
GO

-- Hantera Order
Create or Alter Procedure ProcessOrder (@orderID int)
AS
Begin
	Declare @IDmax int = (select MAX(ID) From OrderLines Where OrderID = @orderID),
			@n int = (Select MIN(ID) From OrderLines Where OrderID = @orderID)			

	while (@n <= @IDmax)
	Begin
		IF Exists (Select ID From OrderLines Where ID = @n AND OrderID = @orderID)
		Begin			 
			Update Products Set Reserved -= (Select Quantity From OrderLines Where ID = @n)
				Where ID = (Select ProductID From OrderLines Where ID = @n)
			Insert into StockTransaction (ProductID, MarkID, Quantity)
				Values ((Select ProductID From OrderLines Where ID = @n), 2, (Select Quantity From OrderLines Where ID = @n))
		END
	Set @n += 1
	END
	Update Orders Set Processed = 1 
		Where ID = @orderID
END
GO

-- Hantera Retur/Reklamation
Create or Alter Procedure OrderReturn (@orderID int, @markID int, @productID int, @quantity int)
AS
Begin
	-- Hantering Retur
	IF (@markID = 3)
	Begin
		Insert into StockTransaction (ProductID, MarkID, Quantity)
			Values (@productID, 3, @quantity)
		Update Products Set InStock += @quantity 
			Where ID = @productID
		Update OrderLines Set Returned += @quantity 
			Where OrderID = @orderID AND ProductID = @productID
	END
	-- Hantering Reklamation
	IF (@markID = 4)
	Begin
		Insert into StockTransaction (ProductID, MarkID, Quantity)
			Values (@productID, 4, @quantity)
		Update OrderLines Set Returned += @quantity 
			Where OrderID = @orderID AND ProductID = @productID
	END
END

