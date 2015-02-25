module Structify
  module Controllers
    class Base
      def id
        'base'
      end

      def to_s
        id
      end

      def receive(arg)
      end
    end
  end
end

Dir[File.expand_path('../controllers', __FILE__) << '/*.rb'].each do |file|
  require file
end
