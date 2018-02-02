class ProductsController < ApplicationController
  before_action :validate_update_params, only: [:update]
  before_action :find_product

  def fetch
    render_external_response
  end

  def update
    @product.price = params[:current_price][:value]
    @product.currency = params[:current_price][:currency_code]

    # Did it fail validation?
    render json: { errors: @product.errors.full_messages }, status: 400 and return if !@product.save

    render_external_response
  end

  private

  # Only called on validated @product
  def render_external_response
    redsky_response = RedskyAPI::get_product_details(@product.id)
    render_error('Product not found', 404) and return if !redsky_response
    render json: { id: @product.id, current_price: { value: @product.price.to_f, currency_code: @product.currency } }.merge(redsky_response)
  end

  def find_product
    @product = Product.find(params[:id])
    render_error('Product not found', 404) and return if !@product
  end

  def validate_update_params
    render_error('current_price was not provided', 400) and return if !params[:current_price].present?
    render_error('current_price.value was not provided', 400) and return if !params[:current_price][:value].present?
    render_error('current_price.currency_code was not provided', 400) and return if !params[:current_price][:currency_code].present?
  end

  def render_error(error, code)
    render json: { errors: [error] }, status: code
  end
end
