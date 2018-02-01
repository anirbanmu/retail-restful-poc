require 'rails_helper'

RSpec.describe 'Products public API', type: :request do
  before(:each) { $redis_raw.flushdb }
  after(:each) { $redis_raw.flushdb }

  describe 'fetch product' do
    it 'returns 404 when ID cannot be found' do
      get product_path(1)
      expect(response.code).to eq('404')
    end

    it 'returns success & object details when ID is found' do
      product = build(:product)
      product.save

      get product_path(product.id)
      expect(response).to be_success

      json_response = json_body
      expect(json_response['id']).to eq(product.id)

      current_price = json_response['current_price']
      expect(current_price['value']).to eq(product.price)
      expect(current_price['currency_code']).to eq(product.currency)
    end
  end

  describe 'update product' do
    context 'parameter validation' do
      it 'returns 404 when there is no record to update' do
        put update_product_path(1), params: { current_price: { value: 1, currency_code: 'USD' } }
        expect(response.code).to eq('404')
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
      product = build(:product)
      product.save

      put update_product_path(product.id), params: { current_price: { value: 1, currency_code: 'SGD' } }
      expect(response).to be_success
    end
  end

  def json_body
    JSON.parse(response.body)
  end
end
