module NameChecker
  class Railties < ::Rails::Railtie
    initializer 'Rails logger' do
      NameChecker::Logging.logger = Rails.logger
    end
  end
end
