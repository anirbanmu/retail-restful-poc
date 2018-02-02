require 'rails_helper'

RSpec.describe 'Products public API', :vcr, type: :request do
  before(:each) { $redis_raw.flushdb }
  after(:each) { $redis_raw.flushdb }

  describe 'fetch product' do
    it 'returns 404 when ID cannot be found' do
      get product_path(1)
      expect(response.code).to eq('404')
    end

    it 'returns success & object details when ID is found' do
      product = build(:product, id: 13860428)
      product.save

      get product_path(product.id)
      expect(response).to be_success

      product_details = { 'id' => product.id, 'name' => 'The Big Lebowski (Blu-ray)',
                          'current_price' => { 'value' => product.price, 'currency_code' => product.currency } }
      expect(json_body).to eq(product_details)
    end
  end

  describe 'update product' do
    context 'parameter validation' do
      it 'returns 404 when there is no record to update' do
        put update_product_path(1), params: { current_price: { value: 1, currency_code: 'USD' } }
        expect(response.code).to eq('404')
        expect(json_body['errors']).to include(/not found/i)
      end

      it 'returns 400 when current_price is missing from payload' do
        put update_product_path(1)
        expect(response.code).to eq('400')
        expect(json_body['errors']).to include(/current_price/i)
      end

      it 'returns 400 when current_price.value is missing from payload' do
        put update_product_path(1), params: { current_price: { currency_code: 'USD' } }
        expect(response.code).to eq('400')
        expect(json_body['errors']).to include(/value/i)
      end

      it 'returns 400 when current_price.currency_code is missing from payload' do
        put update_product_path(1), params: { current_price: { value: 1 } }
        expect(response.code).to eq('400')
        expect(json_body['errors']).to include(/currency_code/i)
      end
    end

    it 'returns success when update went through' do
      product = build(:product, id: 13860428)
      product.save

      updated_price = { current_price: { 'value' => 1, 'currency_code' => 'SGD' } }

      put update_product_path(product.id), params: updated_price
      expect(response).to be_success

      updated_product_details = { 'id' => product.id, 'name' => 'The Big Lebowski (Blu-ray)',
                                  'current_price' => updated_price[:current_price] }
      expect(json_body).to eq(updated_product_details)
    end
  end

  def json_body
    JSON.parse(response.body)
  end
end
