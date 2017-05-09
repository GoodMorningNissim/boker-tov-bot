require 'boker_tov_bot/message_handlers/base_handler'

module BokerTovBot
  module MessageHandlers
    class ThhHandler < BaseHandler
      def initialize(options = {})
        @regex = /\b(ט+ח+)\b/mi
        super(options)
      end

      def match?(message)
        @regex.match(message.downcase) ? true : false
      end

      def response(message)
        reply_with_probability(1.0) do
          response_arr = []
          message.downcase.split.each do |word|
            response_arr << (match?(word) ? word.gsub(/[טח]/, 'ט' => 'פ', 'ח' => 'ף') : word)
          end
          [:text, response_arr.join(' ')]
        end
      end
    end
  end
end
