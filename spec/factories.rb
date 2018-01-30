FactoryBot.define do
  factory :product do
    id { SecureRandom.hex }
    price { Random.rand.round(2) }
    currency { 'USD' }
  end
end
