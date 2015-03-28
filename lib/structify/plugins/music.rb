class Structify::Plugins::Music < Structify::Plugins::Base
  def initialize(state=nil)
    @state = state
  end

  def id
    'co.randompaper.structify.music'
  end

  def apply(state, context)
    context = {
      type: :playlist,
      entry: 'Purchased Musics'
    }
    context = {
      type: :music,
      entry: 'Change!'
    }
    context = {
      type: :random
    }
    if state == :activate
      puts "iTunesController: playing music with #{@state}"
    elsif state == :deactivate
      puts "iTunesController: paused music with #{@state}"
    end
  end
end
