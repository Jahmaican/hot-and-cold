class Player
  SPEED = 0.3
  @@hot = nil
  @@cold = nil
  
  def initialize(win, x, y)
    @win = win
    @x, @y = x, y
    @@hot = Image.load_tiles(win, "media/playerhot.png", 8, 8, true)
    @@cold = Image.load_tiles(win, "media/playercold.png", 8, 8, true)
    @@extras = Image.load_tiles(win, "media/extras.png", 8, 8, true)
    @sprite = @@hot
    
    @side = 0 # 0 - down, 1 - right, 2 - left, 3 - up
    @frame = 0 # 0 - stand; 1, 2 - move
  end
  
  def update
    @speed = double_keys? ? SPEED/1.41 : SPEED
    
    @frame = 0
    
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
  
  def switch_world(world)
    @sprite = world == :cold ? @@cold : @@hot
  end
  
  def animate
    @frame = 1 + (milliseconds/100)%2
  end
  
  def can_move?(dir)
    case dir
    when :left
      (16 .. 32).include?(@win.map.map[((@x+1+@speed)/8).to_i][((@y+@speed)/8).to_i + 1])
    when :right
      (16 .. 32).include?(@win.map.map[((@x+7+@speed)/8).to_i][((@y+@speed)/8).to_i + 1])
    when :up
      (16 .. 32).include?(@win.map.map[((@x+4+@speed)/8).to_i][((@y-6+@speed)/8).to_i + 1])
    when :down
      (16 .. 32).include?(@win.map.map[((@x+4+@speed)/8).to_i][((@y+1+@speed)/8).to_i + 1])
    end
  end
  
  def double_keys?
    ((@win.button_down? KbS or @win.button_down? KbW or @win.button_down? KbUp or @win.button_down? KbDown) and
    (@win.button_down? KbA or @win.button_down? KbD or @win.button_down? KbLeft or @win.button_down? KbRight))
  end
  
  def draw
    @sprite[@side*8 + @frame].draw(@x, @y, 10)
    @@extras[0+(milliseconds/300)%4].draw(32, 24, 5)
    @@extras[8].draw(32, 8, 5)
    @@extras[16+(milliseconds/100)%4].draw(48, 24, 5)
  end
end