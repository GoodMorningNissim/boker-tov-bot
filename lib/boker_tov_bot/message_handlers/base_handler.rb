module BokerTovBot
  module MessageHandlers
    class BaseHandler
      def initialize(options = {})
        @reply_probability = options[:probability] || 0.7
      end

      def match?(message)
        raise NotImplementedError, "#{self.class.name}#match? wasn't implmeneted"
      end

      def response(message)
        raise NotImplementedError, "#{self.class.name}#response wasn't implmeneted"
      end

      def reply_with_probability(probability = @reply_probability, &block)
        if rand <= probability
          yield
        else
          [:skip, nil]
        end
      end
    end
  end
end
