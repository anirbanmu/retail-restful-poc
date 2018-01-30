class Product
  include ActiveModel::Validations

  attr_accessor :id, :price, :currency

  validates_presence_of :id
  validates_numericality_of :price
  validates_presence_of :currency
  validate :validate_currency

  def initialize(attributes = {})
    attributes.each do |k, v|
      send("#{k}=", v)
    end
  end

  def save
    return false if !valid?
    'OK' == $redis.mapped_hmset(self.id, { price: self.price, currency: self.currency } )
  end

  def exists?
    $redis.exists(self.id)
  end

  def destroy
    1 == $redis.del(self.id)
  end

  private

  def validate_currency
    errors.add(:currency, 'type is unsupported') if !Money::Currency.find(self.currency)
  end
end
