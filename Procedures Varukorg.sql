use ElGiganto26
GO

-- Visa Varukorgen till en specifik kund
Create Or Alter Procedure ViewCart (@customerID int)
as
Begin
	Select Products.Name, Products.Colour, Products.Size, Cart.Quantity, Products.Price, (Cart.Quantity * Products.Price) AS Total From Cart
	inner join Products on Products.ID = Cart.ProductID
	Where Cart.CustomerID = @customerID
END
GO

-- Procedure för Lägga till i varukorgen
Create or Alter Procedure dbo.AddToCart(@customerID int, @productID int, @quantity int)
as
Declare @productStock int = (select InStock from products Where ID = @productID)
Begin
	--Om produkten redan finns uppdateras antalet
	IF Exists (Select ProductID from Cart where ProductID = @productID AND CustomerID = @customerID)
	Begin
		Update Cart Set Quantity += @quantity
			Where ProductID = @productID
	END
	--Om produkten inte finns lägg den till
	IF NOT EXISTS (Select ProductID from Cart where ProductID = @productID AND CustomerID = @customerID) AND @productStock > 0 
	Begin
		Insert Into Cart (CustomerID, ProductID, Quantity)
		Values( @customerID, @productID, @quantity)
		Update Products Set Popularity += 5 Where ID = @productID
	END
END
GO

--Uppdatera Varukorgen
Create Or Alter Procedure UpdateCart (@customerID int, @productID int, @quantity int)
AS
Begin
	Update Cart Set Quantity += @quantity
	Where CustomerID = @customerID AND ProductID = @productID

	IF(Select Quantity from Cart Where CustomerID = @customerID AND ProductID = @productID) <= 0
	Begin
	Delete From Cart 
	Where CustomerID = @customerID AND ProductID = @productID
	END
END
GO

-- Töm Varukorgen
Create Or Alter Procedure EmptyCart (@customerID int)
AS
Begin
Delete From Cart
	Where CustomerID = @customerID
END
GO

-- Checka ut Varukorgen
Create or Alter Procedure CheckOutCart (@customerID int)
AS
Begin
	Declare @IDmax int,
			@orderID int,
			@n int,
			@productID int,
			@size varchar(10),
			@colour varchar (25),
			@price int,
			@quantity int

	Insert into Orders (CustomerID)
		Values (@customerID)

	set @orderID = (Select SCOPE_IDENTITY())
	set @IDmax = (Select MAX(ID) From Cart Where CustomerID = @customerID)
	set @n = (Select MIN(ID) From Cart Where CustomerID = @customerID)

	while (@n <= @IDmax)
	Begin
		IF Exists (Select ID From Cart Where ID = @n AND CustomerID = @customerID)
		Begin
			Set @productID = (Select ProductID From Cart Where ID = @n)
			Set @size = (Select Size From Products Where ID = @productID)
			Set @colour = (Select Colour From Products Where ID = @productID)
			Set @price = (Select Price From Products Where ID = @productID)
			Set @quantity = (Select Quantity From Cart Where ID = @n)

			Insert Into OrderLines (OrderID, ProductID, Size, Colour, Price, Quantity)
				Values (@orderID, @productID, @size, @colour, @price, @quantity)

			Update Products Set Popularity += 10
				Where ID = @productID
			Update Products Set InStock -= @quantity
				Where ID = @productID
			Update Products Set Reserved += @quantity
				Where ID = @productID
		END
		Set @n += 1 
	END
	Delete From Cart Where CustomerID = @customerID

END