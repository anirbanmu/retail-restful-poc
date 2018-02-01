require 'redsky_api'

describe RedskyAPI do
  describe '.build_product_details_uri' do
    it 'includes correct main API uri & id' do
      id = 1
      expect(RedskyAPI::build_product_details_uri(id).to_s).to match(/redsky\.target\.com.*#{id}/)
    end
  end

  describe '.get_product_details', :vcr do
    it 'returns nil when product id is invalid' do
      id = 'not_a_real_id'
      expect(RedskyAPI::get_product_details(id)).to be_nil
    end

    it 'returns nil when product id is numeric but does not exist' do
      id = 1
      expect(RedskyAPI::get_product_details(id)).to be_nil
    end

    it 'returns product information when id is valid' do
      id = 16696652
      expect(RedskyAPI::get_product_details(id)).to eq({ name: 'Beats Solo 2 Wireless - Black' })
    end
  end
end
