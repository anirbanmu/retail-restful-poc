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

  private

  def validate_currency
    errors.add(:currency, 'type is unsupported') if !Money::Currency.find(@currency)
  end
end
