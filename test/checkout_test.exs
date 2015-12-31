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

  test "The cart is subtotalled without discount", %{cart: items} do
    total = Checkout.scan(items) |> Checkout.subtotal
    assert total == 410.00
  end

  test "The cart is totalled with discounts based on default offers", %{cart: items} do
    offers = [
      %{sku: :A, discount_qualification_quantity: 3, discount: 20},
      %{sku: :B, discount_qualification_quantity: 2, discount: 15}
    ]
    total = Checkout.scan(items) |> Checkout.total(offers)
    assert total == 355.00
  end

  test "The cart is totalled with discounts based on different offers", %{cart: items} do
    offers = [
      %{sku: :A, discount_qualification_quantity: 3, discount: 25},
      %{sku: :B, discount_qualification_quantity: 2, discount: 20}
    ]
    total = Checkout.scan(items) |> Checkout.total(offers)
    assert total == 340.00
  end

end
