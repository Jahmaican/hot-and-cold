class Spell
  attr_reader :x, :y, :angle
  SPEED = 1.0
  
  def initialize(win, x, y, target)
    @win = win
    @x, @y = x, y
    @target_x = target[0]*8 + 4
    @target_y = target[1]*8 + 4
    @target = target
    @angle = Gosu::angle(@x, @y, @target_x, @target_y)
  end
  
  def update
    if !close_enough?
      @x = @x + offset_x(@angle, SPEED)
      @y = @y + offset_y(@angle, SPEED) 
    else
      @win.map.target_hit(@target)
      @win.player.spell = nil
    end
  end
  
  def close_enough?
    distance(@x, @y, @target_x, @target_y)/@win.scale_x < 0.3
  end
  
  def self.can_reach?(win, x, y, target)
    distance(x, y, target[0]*8 + 4, target[1]*8 + 4)/win.scale_x < 4
  end
end