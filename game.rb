require 'gosu'
include Gosu

require_relative 'class/map.rb'
require_relative 'class/player.rb'

class Game < Window
  def initialize
    super 1, 1, false #hack
    super 1024, 576, false
    self.caption = "Hot and Cold"
    enable_undocumented_retrofication
    
    @scale_x = width/336
    @scale_y = height/192
    
    @map = Map.new(self)
    @player = Player.new(self, 32, 24)
    @world = :cold
  end
  
  def button_down(id)
    case(id)
    when KbQ
      @world = @world == :cold ? :hot : :cold
      @map.switch_world(@world)
      @player.switch_world(@world)
    when KbEscape
      close
    end
  end
  
  def update
    @player.update
  end

  def draw
    scale(@scale_x, @scale_y) {
      @player.draw
      @map.draw
    }
  end
end

Game.new.show