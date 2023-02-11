module Helpers
  module Request
    def body
      JSON.parse(response.body)
    end
  end
end

RSpec.configure do |config|
  config.include Helpers::Request, type: :request
end
