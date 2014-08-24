class Player
  attr_accessor :x, :y, :cursor_frame, :target, :spell, :switch_timer, :has_key
  
  SPEED = 0.3
  
  @@hot = nil
  @@cold = nil
  @@manabar = nil
  @@cursor = nil
  
  def initialize(win, x, y)
    @win = win
    @x, @y = x, y
    @sprite = @@hot
    @target = nil
    @spell = nil
    @blue_mana = 5
    @red_mana = 5
    @side = 0 # 0 - down, 1 - right, 2 - left, 3 - up
    @frame = 0 # 0 - stand; 1, 2 - move
    @cursor_frame = 0
    @switch_timer = Timer.new
    @has_key = false
  end
  
  def update
    @speed = double_keys? ? SPEED/1.41 : SPEED
    @frame = 0
    @spell.update if @spell != nil
    
    if @win.button_down? KbA or @win.button_down? KbLeft and can_move?(:left)
      @x = @x - @speed
      @side = 2
      animate
    end
    
    if @win.button_down? KbD or @win.button_down? KbRight and can_move?(:right)
      @x = @x + @speed
      @side = 1
      animate
    end
    
    if @win.button_down? KbW or @win.button_down? KbUp and can_move?(:up)
      @y = @y - @speed
      @side = 3
      animate
    end
    
    if @win.button_down? KbS or @win.button_down? KbDown and can_move?(:down)
      @y = @y + @speed
      @side = 0
      animate
    end
  end
  
  def cast_spell
    if @target != nil and @spell == nil
      if Spell.can_reach?(@x+4, @y+4, @target)
        @spell = Spell.new(@win, @x+4, @y+4, @target)
      end
    end
  end
  
  def switch_world(world)
    @sprite = world == :cold ? @@hot : @@cold
  end
  
  def animate
    @frame = 1 + (milliseconds/100)%2
  end
  
  def can_move?(dir)
    case dir
    when :left
      ![0, 4, 5, 16, 17, 18].include?(@win.map.obj[((@x+1+@speed)/8).to_i][((@y+@speed)/8).to_i + 1]) and
      (16 .. 31).include?(@win.map.map[((@x+1+@speed)/8).to_i][((@y+@speed)/8).to_i + 1])
    when :right
      ![0, 4, 5, 16, 17, 18].include?(@win.map.obj[((@x+7+@speed)/8).to_i][((@y+@speed)/8).to_i + 1]) and
      (16 .. 31).include?(@win.map.map[((@x+7+@speed)/8).to_i][((@y+@speed)/8).to_i + 1])
    when :up
      ![0, 4, 5, 16, 17, 18].include?(@win.map.obj[((@x+4+@speed)/8).to_i][((@y-6+@speed)/8).to_i + 1]) and
      (16 .. 31).include?(@win.map.map[((@x+4+@speed)/8).to_i][((@y-6+@speed)/8).to_i + 1])
    when :down
      ![0, 4, 5, 16, 17, 18].include?(@win.map.obj[((@x+4+@speed)/8).to_i][((@y+1+@speed)/8).to_i + 1]) and
      (16 .. 31).include?(@win.map.map[((@x+4+@speed)/8).to_i][((@y+1+@speed)/8).to_i + 1])
    end
  end
  
  def can_switch?
    (16 .. 31).include?(@win.map.map_cold[((@x+4)/8).to_i][((@y)/8).to_i + 1]) and
    (16 .. 31).include?(@win.map.map_hot[((@x+4)/8).to_i][((@y)/8).to_i + 1]) and
    @spell == nil and @switch_timer.time > 1000
  end
  
  def double_keys?
    ((@win.button_down? KbS or @win.button_down? KbW or @win.button_down? KbUp or @win.button_down? KbDown) and
    (@win.button_down? KbA or @win.button_down? KbD or @win.button_down? KbLeft or @win.button_down? KbRight))
  end
  
  def self.set_hot(img)
    @@hot = img
  end
  
  def self.set_cold(img)
    @@cold = img
  end
  
  def self.set_manabar(img)
    @@manabar = img
  end
  
  def self.set_cursor(img)
    @@cursor = img
  end
  
  def draw
    @@cursor[@cursor_frame].draw(@win.mouse_x/@win.scale_x - 2, @win.mouse_y/@win.scale_y - 2, 30)
    @sprite[@side*8 + @frame].draw(@x, @y, 10)
    @@manabar[5 - @red_mana].draw(220, (@win.world == :cold ? 0+Math::sin((milliseconds/300.0)) : 0), 15) if @red_mana > 0
    @@manabar[10 - @blue_mana].draw(271, (@win.world == :hot ? 0+Math::sin((milliseconds/300.0)) : 0), 15) if @blue_mana > 0
    @sprite[32+(milliseconds/100)%3].draw_rot(@spell.x, @spell.y, 11, @spell.angle) if @spell != nil
  end
end