FactoryBot.define do
  factory :product do
    id { SecureRandom.hex.to_s }
    price { Random.rand.round(2).to_s }
    currency { 'USD' }
  end
end
