defmodule Checkout do

  def scan(item) when is_map(item), do: scan(item, [])
  #convenience for passing in multiple items
  def scan(items) when is_list(items), do: Enum.reduce(items, [], &(scan(&1, &2)))
  def scan(item, order) when is_list(order), do: [item | order]

  def total(cart) do
    subtotal(cart) - discount(cart)
  end

  def discount(cart) do
    #calculate the discount
    calculate_discount(cart, :A, 3, 20.00) + calculate_discount(cart, :B, 2, 15.00)
  end

  defp calculate_discount(cart, sku, discount_qualification_amount, discount_value) do
    cart
      |> filter_by(sku)
      |> count
      |> calculate_discount(discount_qualification_amount, discount_value)
  end

  defp filter_by(cart, sku) do
    Enum.filter(cart, &(&1.sku == sku))
  end

  defp count(items) do
    Enum.reduce(items, 0, fn(item, total) -> item.quantity + total end)
  end

  defp calculate_discount(items_count, discount_qualification_amount, discount_value) do
    Float.floor(items_count / discount_qualification_amount, 0) * discount_value
  end

  def subtotal(cart) do
    Enum.reduce cart, 0, fn(item, running_total) ->
      (item.price * item.quantity) + running_total
    end
  end

end
