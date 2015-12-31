defmodule Checkout do

  def scan(item) when is_map(item), do: scan(item, [])
  #convenience for passing in multiple items
  def scan(items) when is_list(items), do: Enum.reduce(items, [], &(scan(&1, &2)))
  def scan(item, order) when is_list(order), do: [item | order]

  def total(cart, offers) do
    subtotal(cart) - discount(cart, offers)
  end

  def discount(cart, offers) do
    Enum.reduce(offers, 0, fn(offer, total) -> calculate_discount(cart, offer) + total end)
  end

  defp calculate_discount(cart, offer) do
    cart
      |> filter_by(offer.sku)
      |> count
      |> calculate_discount(offer.discount_qualification_quantity, offer.discount)
  end

  defp filter_by(cart, sku) do
    Enum.filter(cart, &(&1.sku == sku))
  end

  defp count(items) do
    Enum.reduce(items, 0, fn(item, total) -> item.quantity + total end)
  end

  defp calculate_discount(items_count, discount_qualification_quantity, discount_value) do
    Float.floor(items_count / discount_qualification_quantity, 0) * discount_value
  end

  def subtotal(cart) do
    Enum.reduce cart, 0, fn(item, running_total) ->
      (item.price * item.quantity) + running_total
    end
  end

end
