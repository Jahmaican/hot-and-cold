class Menu
  attr_reader :action
  @@title_screen = nil
  @@buttons = nil
  @@mbuttons = nil
  
  def initialize(win)
    @win = win
    
    @active = Array.new(7, false)
    @action = nil
  end
  
  def update
    @action = nil
    if (26 .. 71).include?((@win.mouse_x/@win.scale_x).to_i) and (100 .. 145).include?((@win.mouse_y/@win.scale_y).to_i)
      @active.insert(0, true)
      @action = "tutorial"
    else
      @active.insert(0, false)
    end
    
    if (91 .. 136).include?((@win.mouse_x/@win.scale_x).to_i) and (100 .. 145).include?((@win.mouse_y/@win.scale_y).to_i)
      @active.insert(1, true)
      @action = "level1"
    else
      @active.insert(1, false)
    end
    
    if (149 .. 194).include?((@win.mouse_x/@win.scale_x).to_i) and (100 .. 145).include?((@win.mouse_y/@win.scale_y).to_i)
      @active.insert(2, true)
      @action = "level2"
    else
      @active.insert(2, false)
    end
    
    if (207 .. 252).include?((@win.mouse_x/@win.scale_x).to_i) and (100 .. 145).include?((@win.mouse_y/@win.scale_y).to_i)
      @active.insert(3, true)
      @action = "level3"
    else
      @active.insert(3, false)
    end
    
    if (265 .. 310).include?((@win.mouse_x/@win.scale_x).to_i) and (100 .. 145).include?((@win.mouse_y/@win.scale_y).to_i)
      @active.insert(4, true)
      @action = "level4"
    else
      @active.insert(4, false)
    end
    
    if (252 .. 277).include?((@win.mouse_x/@win.scale_x).to_i) and (156 .. 181).include?((@win.mouse_y/@win.scale_y).to_i)
      @active.insert(5, true)
      @action = "help"
    else
      @active.insert(5, false)
    end
    
    if (297 .. 322).include?((@win.mouse_x/@win.scale_x).to_i) and (156 .. 181).include?((@win.mouse_y/@win.scale_y).to_i)
      @active.insert(6, true)
      @action = "exit"
    else
      @active.insert(6, false)
    end
  end
  
  def self.set_title_screen(img)
    @@title_screen = img
  end
  
  def self.set_buttons(img)
    @@buttons = img
  end
  
  def self.set_mbuttons(img)
    @@mbuttons = img
  end
  
  def draw
    @@title_screen.draw(0,0,1)
    @@buttons[@active[0] ? 1 : 0].draw(26, 100, 2)
    @@buttons[@active[1] ? 3 : 2].draw(91, 100, 2)
    @@buttons[@active[2] ? 5 : 4].draw(149, 100, 2)
    @@buttons[@active[3] ? 7 : 6].draw(207, 100, 2)
    @@buttons[@active[4] ? 9 : 8].draw(265, 100, 2)
    @@mbuttons[@active[5] ? 1 : 0].draw(252, 156, 2)
    @@mbuttons[@active[6] ? 3 : 2].draw(297, 156, 2)
  end
end