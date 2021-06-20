
class Inventory::CreateProduct < Micro::Case
  flow self.call!

  attributes :company, :params

  validates :company, kind: Company
  validates :params, kind: ActionController::Parameters

  def call!
    product_params = params.require(:product).permit(:sku, :name, :description)

    product = company.inventory_products.create!(product_params)

    Success result: { product: product }
  rescue ActiveRecord::RecordInvalid => e
    Failure :invalid_product, result: { errors: product.errors }
  rescue ActionController::ParameterMissing => e
    Failure :parameter_missing, result: { message: e.message }
  end
end