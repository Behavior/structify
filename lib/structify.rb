require 'pp'
require 'pry-byebug'

require 'structify/cabocha'
require 'structify/controllers'
require 'structify/parser'
require 'structify/version'

module Structify
  private

  def self.controllers
    ObjectSpace.each_object(Controllers::Base.singleton_class).select{ |klass| klass.superclass == Controllers::Base }
  end
end
