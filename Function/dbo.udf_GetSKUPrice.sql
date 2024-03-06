-- Функция вычисления цены товара, ID которого передан, из суммарной стоимости и суммарного количества в корзине
create or alter function dbo.udf_GetSKUPrice(
	@ID_SKU int
)
returns decimal(18, 2)
as
begin
	declare @Price decimal(18, 2)

	select @Price = sum(b.[Value]) / sum(b.Quantity)
	from dbo.Basket as b
	where b.ID_SKU = @ID_SKU

	return @Price
end