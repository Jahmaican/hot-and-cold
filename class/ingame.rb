class Ingame
  attr_reader :action
  
  @@box = nil
  @@buttons = nil
  @@font = nil
  
  def initialize(win)
    @win = win
    
    @message = nil
    @b1text = nil
    @b1action = nil
    @b2text = nil
    @b2action = nil
    @active = Array.new(7, false)
    @action = nil
  end
  
  def update
    @action = nil
    if (215 .. 271).include?((@win.mouse_x/@win.scale_x).to_i) and (135 .. 167).include?((@win.mouse_y/@win.scale_y).to_i)
      @active.insert(0, true)
      @action = @b1action
    else
      @active.insert(0, false)
    end
    
    if (58 .. 122).include?((@win.mouse_x/@win.scale_x).to_i) and (135 .. 167).include?((@win.mouse_y/@win.scale_y).to_i)
      @active.insert(1, true)
      @action = @b2action
    else
      @active.insert(1, false)
    end
  end
  
  def set_info(message, b1text="OK!", b1action="continue", b2text = nil, b2action = nil)
    @message = Image.from_text(@win, message, "media/alphbeta.ttf", 16, 3, 200, :left)
    @b1text = b1text
    @b1action = b1action
    @b2text = b2text
    @b2action = b2action
  end
  
  def self.set_box(img)
    @@box = img
  end
  
  def self.set_buttons(img)
    @@buttons = img
  end
  
  def self.set_font(font)
    @@font = font
  end
  
  def draw
    @@box.draw(0,0,20)
    @@buttons[@active[0] ? 1 : 0].draw(215, 135, 20)
    @@buttons[@active[1] ? 1 : 0].draw(58, 135, 20) if @b2text != nil
    @@font.draw_rel(@b1text, 247, 151, 21, 0.5, 0.5, 1, 1, color = 0xff000000)
    @@font.draw_rel(@b2text, 90, 151, 21, 0.5, 0.5, 1, 1, color = 0xff000000)
    @message.draw(73, 38, 21, 1, 1, 0xff000000)
  end
end