require 'rails_helper'

RSpec.describe Product do
  before(:each) { $redis_raw.flushdb }
  after(:each) { $redis_raw.flushdb }

  it 'creates valid product' do
    product = build(:product)
    expect(product).to be_valid
  end

  context 'attribute validation' do
    it 'rejects nil id' do
      product = build(:product, id: nil)
      expect(product).to be_invalid
      expect(product.errors[:id]).to_not be_empty
    end

    it 'rejects blank id' do
      product = build(:product, id: '')
      expect(product).to be_invalid
      expect(product.errors[:id]).to_not be_empty
    end

    it 'rejects nil price' do
      product = build(:product, price: nil)
      expect(product).to be_invalid
      expect(product.errors[:price]).to_not be_empty
    end

    it 'rejects blank price' do
      product = build(:product, price: '')
      expect(product).to be_invalid
      expect(product.errors[:price]).to_not be_empty
    end

    it 'rejects non-numerical price' do
      product = build(:product, price: '7848a')
      expect(product).to be_invalid
      expect(product.errors[:price]).to_not be_empty
    end

    it 'rejects nil currency' do
      product = build(:product, currency: nil)
      expect(product).to be_invalid
      expect(product.errors[:currency]).to_not be_empty
    end

    it 'rejects blank currency' do
      product = build(:product, currency: '')
      expect(product).to be_invalid
      expect(product.errors[:currency]).to_not be_empty
    end

    it 'rejects invalid currency' do
      product = build(:product, currency: 'jfdgju4')
      expect(product).to be_invalid
      expect(product.errors[:currency]).to_not be_empty
    end
  end

  describe '#save' do
    context 'when valid' do
      it 'saves to redis and returns true' do
        product = build(:product)
        save_result = false
        expect{ save_result = product.save }.to change{ $redis_raw.dbsize }.by(1)
        expect(save_result).to be true

        redis_key = Product.generate_redis_key(product.id)
        expect($redis.hmget(redis_key, 'price').first).to eq(product.price.to_s)
        expect($redis.hmget(redis_key, 'currency').first).to eq(product.currency)
      end
    end

    context 'when invalid' do
      it 'does not save to redis and returns false' do
        product = build(:product, id: nil)
        save_result = true
        expect{ save_result = product.save }.to_not change{ $redis_raw.dbsize }
        expect(save_result).to be false
      end
    end
  end

  describe '#destroy' do
    context 'when record exists' do
      it 'deletes record and returns true' do
        $redis.set(Product.generate_redis_key(1), "")
        destroy_result = false
        expect{ destroy_result = build(:product, id: 1).destroy }.to change{ $redis_raw.dbsize }.by(-1)
        expect(destroy_result).to be true
      end
    end

    context 'when record does not exist' do
      it 'does nothing & returns false if record does not exist' do
        destroy_result = true
        expect{ destroy_result = build(:product).destroy }.to_not change{ $redis_raw.dbsize }
        expect(destroy_result).to be false
      end
    end
  end


  describe '.exists?' do
    it 'returns false when no record exists' do
      expect(Product.exists?(1)).to be false
    end

    it 'returns true when record exists' do
      $redis.set(Product.generate_redis_key(1), "")
      expect(Product.exists?(1)).to be true
    end
  end

  describe '.find' do
    context 'when record exists' do
      it 'returns new Product object with correct values' do
        product_to_save = build(:product)
        product_to_save.save

        found = Product.find(product_to_save.id)
        expect(found.id).to eq(product_to_save.id)
        expect(found.price).to eq(product_to_save.price)
        expect(found.currency).to eq(product_to_save.currency)
      end
    end

    context 'when record does not exist' do
      it 'returns nil' do
        expect(Product.find(1)).to be nil
      end
    end
  end
end
