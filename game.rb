require 'gosu'
include Gosu

class Game < Window
  def initialize
     super 640, 360, false
     self.caption = "Brilliant Game"
  end
  
  def button_down(id)
    case(id)
    when KbEscape
      close
    end
  end
  
  def update
    
  end

  def draw
    
  end
end

$game = Game.new
$game.show