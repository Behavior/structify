module Structify
  module Plugins
    class Base
      def id
        'base'
      end

      def to_s
        id
      end
    end
  end
end

Dir[File.expand_path('../plugins', __FILE__) << '/*.rb'].each do |file|
  require file
end
