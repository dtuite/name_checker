module RSpecSupportSpecHelpers
  # Gets the currently described class.
  # Conversely to +subject+, it returns the class
  # instead of an instance.
  def klass
    described_class
  end
end

RSpec.configure do |config|
  config.include RSpecSupportSpecHelpers
end
