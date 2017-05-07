
module BokerTovBot
  class Runner
    MANDATORY_CONFIG_FIELDS = [:token, :message_handlers]
    def initialize(options = {})
      verify_options(options)
      @options = options
    end

    def run
      message_handlers = @options[:message_handlers]
      Telegram::Bot::Client.run(@options[:token]) do |bot|
        bot.listen do |incoming_message|
          case incoming_message.text
          when '/start'
            bot.api.send_message(chat_id: incoming_message.chat.id, text: "Hello, #{incoming_message.from.first_name}")
          when '/stop'
            bot.api.send_message(chat_id: incoming_message.chat.id, text: "Bye, #{incoming_message.from.first_name}")
          else
            handler = message_handlers.find do |message_handler|
              begin
                message_handler.match?(incoming_message.text)
              rescue NotImplementedError => e
                next
              rescue Exception => e
                next
              end
            end
            if handler
              send_response(handler, bot, incoming_message)
            end
          end
        end
      end
    end

    private

    def send_response(message_handler, bot, incoming_message)
      type, response = message_handler.response(incoming_message.text)
      case type
      when :image
        bot.api.send_photo(chat_id: incoming_message.chat.id, photo: response)
      when :text
        bot.api.send_message(chat_id: incoming_message.chat.id, text: response)
      else
      end
    end

    def verify_options(options)
      missing_fields = MANDATORY_CONFIG_FIELDS - options.keys
      if !missing_fields.empty?
        raise ArgumentError, "required fields: #{MANDATORY_CONFIG_FIELDS.join(', ')}, given: #{options.keys.join(', ')}"
      end
    end
  end
end
