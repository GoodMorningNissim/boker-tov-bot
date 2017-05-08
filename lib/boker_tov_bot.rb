
require 'telegram/bot'
require 'active_support/inflector'
require 'boker_tov_bot/config'
require 'boker_tov_bot/runner'
require 'boker_tov_bot/version'

Dir.glob(File.join(File.dirname(__FILE__), 'boker_tov_bot', 'message_handlers', '*.rb')).each do |f|
  if File.basename(f) == 'base_handler.rb'
    next
  end
  require f
end

module BokerTovBot
  def self.run(options = {})
    token = BokerTovBot::Config.instance.token
    message_handlers = BokerTovBot::MessageHandlers.constants(false).map do |k|
      if BokerTovBot::MessageHandlers.const_get(k).instance_of?(Class)
        "BokerTovBot::MessageHandlers::#{k}".constantize.new
      end
    end.compact
    runner = BokerTovBot::Runner.new(token: token, message_handlers: message_handlers)
    runner.run
  end
end
