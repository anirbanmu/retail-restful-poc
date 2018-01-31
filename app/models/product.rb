class Product
  include ActiveModel::Validations

  attr_accessor :id, :price, :currency

  validates_presence_of :id
  validates_numericality_of :id, only_integer: true
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
    'OK' == $redis.mapped_hmset(redis_key, { price: self.price, currency: self.currency } )
  end

  def exists?
    $redis.exists(redis_key)
  end

  def destroy
    1 == $redis.del(redis_key)
  end

  def self.find(id)
    properties = $redis.hgetall(generate_redis_key(id))
    return nil if properties.empty?
    Product.new(id: id.to_i, price: properties['price'].to_f, currency: properties['currency'])
  end

  private

  def redis_key
    @redis_key ||= self.class.generate_redis_key(self.id)
  end

  def self.generate_redis_key(id)
    "products:#{id}"
  end

  def validate_currency
    errors.add(:currency, 'type is unsupported') if !Money::Currency.find(self.currency)
  end
end
