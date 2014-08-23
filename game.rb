require 'gosu'
include Gosu

require_relative 'class/menu.rb'
require_relative 'class/map.rb'
require_relative 'class/player.rb'

class Game < Window
  attr_reader :map, :scale_x, :scale_y
  def initialize
    super 1, 1, false #hack
    super screen_width, screen_height, true
    self.caption = "Hot and Cold"
    enable_undocumented_retrofication
    
    @state = :menu
    
    @scale_x = width/336.0
    @scale_y = height/192.0
    
    @menu = Menu.new(self)
    @world = :cold
  end
  
  def button_down(id)
    case @state
    when :menu
      case(id)
      when MsLeft
        if @menu.action != nil
          if @menu.action == "help"
            
          elsif @menu.action == "exit"
            close
          else
            @map = Map.new(self, @menu.action)
            @player = Player.new(self, 32, 24)
            @state = :level
          end
        end
        
      when KbEscape
        close
      end
      
    when :level
      case(id)
      when KbQ
        @world = @world == :cold ? :hot : :cold
        @map.switch_world(@world)
        @player.switch_world(@world)
      when KbEscape
        close
      end
    end
  end
  
  def update
    case @state
    when :menu
      @menu.update
    when :level
      @player.update
    end
  end
  
  def needs_cursor?
    case @state
    when :menu
      true
    when :level
      false
    end
  end

  def draw
    case @state
    when :menu
      scale(@scale_x, @scale_y) {
        @menu.draw
      }
    when :level
      scale(@scale_x, @scale_y) {
        @player.draw
        @map.draw
      }
    end
  end
end

Game.new.show