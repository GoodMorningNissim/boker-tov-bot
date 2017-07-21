require 'boker_tov_bot/message_handlers/base_handler'

module BokerTovBot
  module MessageHandlers
    class AmitoHandler < BaseHandler
      def initialize(options = {})
        @regex = /.*(גולדברג|עמית|עמיתו).*/mi
        @responses = ["¯\_(ツ)_/¯", “רדיוהד מופעים פה מחר” ]
        super(options)
      end

      def match?(message)
        @regex.match(message.downcase) ? true : false
      end

      def response(message)
        reply_with_probability(0.7) do
          [:text, @responses.sample]
        end
      end
    end
  end
end
