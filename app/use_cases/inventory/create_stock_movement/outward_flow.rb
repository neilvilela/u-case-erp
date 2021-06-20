module Inventory
  module CreateStockMovement
    class OutwardFlow < Micro::Case
      attributes :product, :params

      validates :product, kind: Inventory::Product
      validates :params, kind: ActionController::Parameters

      def call!
        product.with_lock do
          call(Steps::NormalizeOutwardParams)
            .then(Steps::CreateStockMovement)
            .then(Steps::UpdateProductReservedQuantity)
        end
      rescue ActiveRecord::RecordInvalid => e
        Failure :invalid_stock_movement, result: { errors: e.record.errors.full_messages }
      end
    end
  end
end
