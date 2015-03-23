DECLARE @x XML = 
    '<Orders>
        <Order>
            <Customer>Moe Howard</Customer>
            <Address>123 Main St, Anytown, NY</Address>
            <OrderItems>
                <Item>
                    <ItemName>Table</ItemName>
                    <Quantity>1</Quantity>
                </Item>
                <Item>
                    <ItemName>Chair</ItemName>
                    <Quantity>4</Quantity>
                </Item>
            </OrderItems>
        </Order>
        <Order>
            <Customer>Larry Fine</Customer>
            <Address>456 Broadway Ave, Someplace, TX</Address>
            <OrderItems>
                <Item>
                    <ItemName>Banana Slicer</ItemName>
                    <Quantity>1</Quantity>
                </Item>
            </OrderItems>
        </Order>
        <Order>
            <Customer>Shemp Howard</Customer>
            <Address>789 Euclid Rd, Random, ID</Address>
            <OrderItems>
                <Item>
                    <ItemName>Hammer</ItemName>
                    <Quantity>1</Quantity>
                </Item>
                <Item>
                    <ItemName>Nails</ItemName>
                    <Quantity>50</Quantity>
                </Item>
                <Item>
                    <ItemName>Chisel</ItemName>
                    <Quantity>2</Quantity>
                </Item>
            </OrderItems>
        </Order>
    </Orders>'


DECLARE @Order TABLE (
        [OrderID] int IDENTITY(1001,1) PRIMARY KEY,
	    [Customer] varchar(200) NOT NULL,
	    [Address] varchar(200) NOT NULL
    )

DECLARE @OrderItem TABLE (
	    [OrderItemID] int IDENTITY(5001,1) PRIMARY KEY,
	    [OrderID] int,
	    [ItemName] varchar(100) NOT NULL,
	    [Quantity] int NOT NULL
    )

INSERT INTO @Order (Customer, Address)
SELECT  t.c.value('(Customer)[1]','varchar(200)'),  
		t.c.value('(Address)[1]','varchar(200)')
FROM    @x.nodes('Orders/Order') t(c);


INSERT INTO @OrderItem (OrderID, ItemName, Quantity)
SELECT  
		Ordr.OrderID
		, Item.n.value('./ItemName[1]','varchar(200)') AS ItemName
		, Item.n.value('./Quantity[1]','int') AS Quantity
FROM    @x.nodes('Orders/Order') Ord(n)
	CROSS APPLY Ord.n.nodes('./OrderItems/Item') AS Item(n)
	JOIN @Order Ordr ON Ordr.Customer = Ord.n.value('./Customer[1]','varchar(200)')

SELECT *
FROM @Order

SELECT *
FROM @OrderItem

GO

DECLARE @x XML = '<locale en-US="Test &amp; Data" />'
SELECT t.c.value('@en-US','VARCHAR(200)')
FROM @x.nodes('locale') t(c)