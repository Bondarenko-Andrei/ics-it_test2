/*
Триггер, добавляющий скидку в 5% от стоимости для товаров, 
которые добавлены в корзину несколькими записями в рамках одного insert или update
*/
create or alter trigger dbo.TR_Basket_insert_update 
on dbo.Basket
after insert, update
as
begin
	with cte_InsertSKUCount as (
		select 
			ID_SKU
			,count(*) as SKUCount
		from inserted
		group by ID_SKU
	)
	update b
	set b.DiscountValue = iif(isc.SKUCount > 1, b.[Value] * 0.05, 0)
	from dbo.Basket as b
		inner join inserted as i on i.ID = b.ID
		inner join cte_InsertSKUCount as isc on isc.ID_SKU = b.ID_SKU
end