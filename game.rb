require 'gosu'
include Gosu

require_relative 'class/map.rb'
require_relative 'class/player.rb'

class Game < Window
  def initialize
    super 1, 1, false #hack
    super screen_width, screen_height, true
    self.caption = "Hot and Cold"
    enable_undocumented_retrofication
    
    @scale_x = screen_width/336
    @scale_y = screen_height/192
    
    @map = Map.new(self)
    @world = :cold
  end
  
  def button_down(id)
    case(id)
    when KbQ
      @world = @world == :cold ? :hot : :cold
      @map.switch_world(@world)
    when KbEscape
      close
    end
  end
  
  def update
    
  end

  def draw
    scale(@scale_x, @scale_y) {
      @map.draw
    }
  end
end

Game.new.show