defmodule CheckoutTest do
  use ExUnit.Case

  setup do
    items = [
      %{sku: :A, price: 50.00, quantity: 3},
      %{sku: :A, price: 50.00, quantity: 2},
      %{sku: :A, price: 50.00, quantity: 1},
      %{sku: :B, price: 30.00, quantity: 1},
      %{sku: :B, price: 30.00, quantity: 1},
      %{sku: :B, price: 30.00, quantity: 1},
      %{sku: :C, price: 20.00, quantity: 1},
    ]
    {:ok, cart: items}
  end

  test "The cart is subtotaled without discount", %{cart: items} do
    total = Checkout.scan(items) |> Checkout.subtotal
    assert total == 410.00
  end

  test "The cart is totaled with discount", %{cart: items} do
    total = Checkout.scan(items) |> Checkout.total
    assert total == 355.00
  end

end
