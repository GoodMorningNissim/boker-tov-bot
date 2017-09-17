require 'boker_tov_bot/message_handlers/base_handler'
require 'faraday'
require 'faraday_middleware'
require 'json'

module BokerTovBot
  module MessageHandlers
    class TrumpHandler < BaseHandler
      def initialize(options = {})
        @regex = /.*(טראמפ|דונדל|דונאלד|טרמפ).*/mi
        @trump_url = 'https://api.whatdoestrumpthink.com/api/v1/quotes/random'
        @trump_conn = Faraday.new(
          url: @trump_url
        ) do |conn|
          conn.use FaradayMiddleware::FollowRedirects, limit: 5
          conn.adapter Faraday.default_adapter
        end
        super(options)
      end

      def match?(message)
        @regex.match(message.downcase) ? true : false
      end

      def response(message)
        reply_with_probability(0.7) do
          get_trump_quote
          [:text, get_trump_quote]
        end
      end

      def get_trump_quote
        fact_resp = @trump_conn.get do |req|
          req['number'] = '1'
        end
        if !fact_resp.success?
          raise RuntimeError, "could not get image, #{fact_resp.status}, #{fact_resp.body}"
        end
        resp = JSON.parse(fact_resp.body)
        "Trump: #{resp['message']}"
      end
    end
  end
end
