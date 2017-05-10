require 'boker_tov_bot/message_handlers/base_handler'
require 'faraday'
require 'faraday_middleware'
require 'json'

module BokerTovBot
  module MessageHandlers
    class HatulFactsHandler < BaseHandler
      def initialize(options = {})
        @regex = /=?((\b(עובדה)\b).*(\b(חתול)\b)).*/mi
        @fact_url = "http://catfacts-api.appspot.com/api/facts"
        @fact_conn = Faraday.new(
          url: @fact_url
        ) do |conn|
          conn.use FaradayMiddleware::FollowRedirects, limit: 5
          conn.adapter Faraday.default_adapter
        end
        @fetch_retries = 3
      end

      def match?(message)
        @regex.match(message.downcase) ? true : false
      end

      def response(message)
        # TODO retries?
        begin
          [:text, get_fact]
        rescue Exception => e
          puts e
          [nil, nil]
        end
      end

      def get_fact
        fact_resp = @fact_conn.get do |req|
          req['number'] = '1'
        end
        if !fact_resp.success?
          raise RuntimeError, "could not get image, #{fact_resp.status}, #{fact_resp.body}"
        end
        parsed_fact_resp = JSON.parse(fact_resp.body)
        parsed_fact_resp["facts"].first
      end
    end
  end
end
