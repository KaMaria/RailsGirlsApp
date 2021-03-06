require 'spec_helper'
include ParamsHelper

RSpec.describe ParamsHelper, type: :helper do
  describe '#trim_params' do
    input_params = { country: '  DE', name: ' franka ', email: ' hi@email.com', website: 'https://mywebsite.com '}
    expected_params = { country: 'DE', name: 'franka', email: 'hi@email.com', website: 'https://mywebsite.com'}
    params = helper.trim_params(input_params)

    it "trims all params" do
      expect(params).to eq(expected_params)
    end
  end
end
