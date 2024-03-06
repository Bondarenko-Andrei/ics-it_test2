-- Процедура, вычитающая из бюджета семьи, фамилия которой передана, сумму покупок этой семьи в корзине
create or alter procedure dbo.usp_MakeFamilyPurchase
	@FamilySurName varchar(255)
as
set nocount on
begin
	-- Проверяем, есть ли такая семья в базе данных, если нет - возвращаем сообщение
	if not exists (
		select 1 
		from dbo.Family as f
		where f.SurName = @FamilySurName
	)
	begin
		raiserror('Такой семьи в базе данных не существует.', 3, 1)
		return
	end
	
	-- Создаем переменную @PurchaseValue и записываем в нее сумму покупок семьи
	declare @PurchaseValue decimal(18, 2)

	select @PurchaseValue = sum(b.[Value])
	from dbo.Basket as b 
		inner join dbo.Family as f on f.ID = b.ID_Family 
	where f.SurName = @FamilySurName 

	-- Обновляем значение поля BudgetValue в таблице dbo.Family
	update f
	set f.BudgetValue = f.BudgetValue - @PurchaseValue
	from dbo.Family as f
	where f.SurName = @FamilySurName
end
