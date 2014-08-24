require 'gosu'
include Gosu

require_relative 'class/menu.rb'
require_relative 'class/ingame.rb'
require_relative 'class/map.rb'
require_relative 'class/player.rb'

class Game < Window
  attr_reader :map, :scale_x, :scale_y
  def initialize
    super 1, 1, false #hack
    super screen_width, screen_height, true
    self.caption = "Hot and Cold"
    enable_undocumented_retrofication
    load_images
    
    @state = :menu
    
    @scale_x = width/336.0
    @scale_y = height/192.0
    
    @menu = Menu.new(self)
    @info = Ingame.new(self)
    
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
            @info.set_info("Are you sure you want to quit?", "No", "continue", "Yes", "quit")
            @state = :menu_msg
          else
            @map = Map.new(self, @menu.action)
            @player = Player.new(self, @map.spawn_x, @map.spawn_y)
            @state = :level
          end
        end
        
      when KbEscape
        close
      end
    when :menu_msg
      case(id)
      when MsLeft
        if @info.action != nil
          if @info.action == "quit"
            close
          else
            @state = :menu
          end
        end
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
    when :menu_msg
      @info.update
    when :level
      @player.update
    end
  end
  
  def needs_cursor?
    case @state
    when :menu, :menu_msg
      true
    when :level
      false
    end
  end
  
  def load_images
    Map.set_hot(Image.load_tiles(self, "media/maphot.png", 8, 8, true))
    Map.set_cold(Image.load_tiles(self, "media/mapcold.png", 8, 8, true))
    Map.set_extras(Image.load_tiles(self, "media/extras.png", 8, 8, true))
    Player.set_hot(Image.load_tiles(self, "media/playerhot.png", 8, 8, true))
    Player.set_cold(Image.load_tiles(self, "media/playercold.png", 8, 8, true))
    Menu.set_title_screen(Image.new(self, "media/title_screen.png", true))
    Menu.set_buttons(Image.load_tiles(self, "media/buttons.png", 45, 45, true))
    Menu.set_mbuttons(Image.load_tiles(self, "media/mbuttons.png", 25, 25, true))
    Ingame.set_box(Image.new(self, "media/info.png", true))
    Ingame.set_buttons(Image.load_tiles(self, "media/ibuttons.png", 64, 32, true))
    Ingame.set_font(Font.new(self, "media/alphbeta.ttf", 16))
  end

  def draw
    case @state
    when :menu
      scale(@scale_x, @scale_y) {
        @menu.draw
      }
    when :menu_msg
      scale(@scale_x, @scale_y) {
        @menu.draw
        @info.draw
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