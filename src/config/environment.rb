# Load the rails application
require File.expand_path('../application', __FILE__)


# Initialize the rails application
CodeSwap::Application.configure do
  Rails.logger = Logger.new('ApplicationLog.log')
  Rails.logger.level = 2
end
CodeSwap::Application.initialize!

