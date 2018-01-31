FactoryBot.define do
  factory :product do
    id { Random.rand(2**64) }
    price { Random.rand.round(2) }
    currency { 'USD' }
  end
end
