# Load the rails application
require File.expand_path('../application', __FILE__)


# Initialize the rails application
CodeSwap::Application.initialize!
CodeSwap::Application.configure do
  config.logger = Logger.new('ApplicationLog.log')
  config.log_level = :debug

end
