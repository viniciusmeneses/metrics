module Helpers
  module MicroCase
    def result_double(success: true, **data)
      double = instance_double(Micro::Case::Result, failure?: !success, success?: success, "[]": nil)
      data.each { |key, value| allow(double).to receive(:[]).with(key).and_return(value) }
      double
    end
  end
end

RSpec.configure do |config|
  config.include Helpers::MicroCase
end
