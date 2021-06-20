module Inventory
  module CreateStockMovement
    module Steps
      class UpdateProductReservedQuantity < Micro::Case
        attributes :product, :stock_movement

        def call!
          product.update!(reserved_quantity: product.reserved_quantity + stock_movement.quantity.abs)

          Success result: { product: product, stock_movement: stock_movement }
        end
      end
    end
  end
end
