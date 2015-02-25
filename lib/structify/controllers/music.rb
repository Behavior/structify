module Structify::Controllers
  class Music < Base
    def initialize(state=nil)
      @state = state
    end

    def id
      'co.randompaper.music_controller'
    end

    def receive(state, context)
      if state == :activate
        puts "iTunesController: playing music with #{@state}"
      elsif state == :deactivate
        puts "iTunesController: paused music with #{@state}"
      end
    end
  end
end
