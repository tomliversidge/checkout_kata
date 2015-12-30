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

  defp calculate_discount(cart, identifier, discount_quantity, discount_value) do
    items = Enum.filter(cart, fn(item) ->
      item.sku == identifier
    end)
    total_items_count = Enum.reduce(items, 0, fn(item, acc) -> item.quantity + acc end)
    Float.floor(total_items_count / discount_quantity, 0) * discount_value
  end

  def subtotal(cart) do
    Enum.reduce cart, 0, fn(item, running_total) ->
      (item.price * item.quantity) + running_total
    end
  end

end
