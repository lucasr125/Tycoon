script.Parent.Text = "$"..script.Parent.Parent.Parent.Parent.Parent.Parent.CurrencyToCollect.Value
-- Shows initial value if anything is currently in the CurrencyToCollect


script.Parent.Parent.Parent.Parent.Parent.Parent.CurrencyToCollect.Changed:connect(function(money)
	script.Parent.Text = "$"..money
end)