require 'pp'
require 'pry-byebug'

require 'structify/cabocha'
require 'structify/controllers'
require 'structify/parser'
require 'structify/version'

module Structify
  private

  def self.providers
    ObjectSpace.each_object(Providers::Base.singleton_class).select{ |klass| klass.superclass == Providers::Base }
  end
end
