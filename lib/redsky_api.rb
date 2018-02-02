require 'net/http'

module RedskyAPI
  API_BASE_URI = URI('http://redsky.target.com/v2/pdp/tcin/')

  def self.get_api_response(uri)
    response = Net::HTTP::get_response(uri)
    Rails.logger.warn "RedskyAPI API failed with #{response.code} & body #{response.body}" if !response.is_a?(Net::HTTPSuccess)
    response
  end

  def self.get_product_details(id)
    response = get_api_response(build_product_details_uri(id))
    return { name: JSON.parse(response.body).fetch('product').fetch('item').fetch('product_description').fetch('title') } if response.is_a?(Net::HTTPSuccess)
    nil
  end

  API_PRODUCT_DETAILS_PARAMS = [['excludes', 'taxonomy,price,promotion,bulk_ship,rating_and_review_reviews,rating_and_review_statistics,question_answer_statistics']]
  def self.build_product_details_uri(id)
    uri = URI.join(API_BASE_URI, id.to_s)
    uri.query = URI.encode_www_form(API_PRODUCT_DETAILS_PARAMS)
    uri
  end
end
