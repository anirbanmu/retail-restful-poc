require 'rails_helper'

describe Product do
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

  it 'creates valid product' do
    product = build(:product)
    expect(product).to be_valid
  end
end
