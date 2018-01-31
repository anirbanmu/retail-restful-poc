class ProductsController < ApplicationController
  def fetch
    product = Product.find(params[:id])
    render_bad_request('Product not found', 404) and return if !product

    render json: { id: product.id, current_price: { value: product.price, currency_code: product.currency } }
  end

  def update
    render_bad_request('current_price was not provided', 400) and return if !params[:current_price].present?
    render_bad_request('current_price.value was not provided', 400) and return if !params[:current_price][:value].present?
    render_bad_request('current_price.currency_code was not provided', 400) and return if !params[:current_price][:currency_code].present?

    product = Product.find(params[:id])
    render_bad_request('Product not found', 404) and return if !product

    product.price = params[:current_price][:value]
    product.currency = params[:current_price][:currency_code]

    # Did it fail validation?
    render json: { errors: product.errors.full_messages }.to_json, status: 400 and return if !product.save

    # Return the new information
    render json: { id: product.id, current_price: { value: product.price, currency_code: product.currency } }
  end

  private

  def render_bad_request(error, code)
    render json: { errors: [error] }.to_json, status: code
  end
end
