require 'pp'
require 'pry-byebug'

require 'structify/cabocha'
require 'structify/plugins'
require 'structify/parser'
require 'structify/version'

module Structify
  private

  def self.plugins
    ObjectSpace.each_object(Controllers::Base.singleton_class).select{ |klass| klass.superclass == Controllers::Base }
  end
end
