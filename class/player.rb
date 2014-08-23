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
  
  def switch_world(world)
    @sprite = world == :cold ? @@cold : @@hot
  end
  
  def update
    @speed = double_keys? ? SPEED/1.41 : SPEED
    
    @frame = 0
    
    if @win.button_down? KbA or @win.button_down? KbLeft
      @x = @x - @speed
      @side = 2
      animate
    end
    
    if @win.button_down? KbD or @win.button_down? KbRight
      @x = @x + @speed
      @side = 1
      animate
    end
    
    if @win.button_down? KbW or @win.button_down? KbUp
      @y = @y - @speed
      @side = 3
      animate
    end
    
    if @win.button_down? KbS or @win.button_down? KbDown
      @y = @y + @speed
      @side = 0
      animate
    end
  end
  
  def animate
    @frame = 1 + (milliseconds/100)%2
  end
  
  def double_keys?
    ((@win.button_down? KbS or @win.button_down? KbW or @win.button_down? KbUp or @win.button_down? KbDown) and
    (@win.button_down? KbA or @win.button_down? KbD or @win.button_down? KbLeft or @win.button_down? KbRight))
  end
  
  def draw
    @sprite[@side*8 + @frame].draw(@x, @y, 2)
    @@extras[0+(milliseconds/300)%4].draw(32, 24, 5)
    @@extras[8].draw(32, 8, 5)
  end
end