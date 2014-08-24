class Map
  attr_reader :map, :obj, :spawn_x, :spawn_y, :map_hot, :map_cold
  
  @@hot = nil
  @@cold = nil
  @@extras = nil
  # size 42/24
  
  def initialize(win, level)
    @win = win
    @tiles = @@cold
    
    @spawn_x, @spawn_y = 0, 0
    @fires = []
    @barrels = []
    @signs = []
    @key = []
    @door = []
    
    @map_hot = load_map("levels/" + level + "/" + level + "hot.map")
    @map_cold = load_map("levels/" + level + "/" + level + "cold.map")
    @map = @map_cold
    
    #load_obj("levels/" + level + "/" + level + "hot.obj")
    #load_obj("levels/" + level + "/" + level + "cold.obj")
    @obj_hot = load_obj("levels/" + level + "/" + level + "hot.obj")
    @obj_cold = load_obj("levels/" + level + "/" + level + "cold.obj")
    @obj = @obj_cold
    @objects_to_destroy = []
  end
  
  def load_obj(file)
    temp = []
    File.open(file).each do |line|
      row = []
      line.chars.each do |c|
        row.push(c)
      end
      temp.push(row)
    end
    
    temp=temp.transpose
    obj = []
    temp.each_index do |x|
      row = []
      temp[x].each_index do |y|
        if temp[x][y] == "@"
          @spawn_x = x*8
          @spawn_y = y*8
          row.push(-1)
        elsif temp[x][y] == "f"
          @fires.push([x,y])
          row.push(0)
        elsif temp[x][y] == "b"
          @barrels.push([x,y])
          row.push(16)
        elsif temp[x][y] == "d"
          @door = [x, y]
          row.push(-1)
        elsif temp[x][y] == "k"
          @key = [x, y]
          row.push(-1)
        elsif temp[x][y] == "t"
          @signs.push([x, y])
          row.push(-1)
        else
          row.push(-1)
        end
      end
      obj.push(row)
    end
    obj
  end
  
  def load_map(file)
    temp = []
    File.open(file).each do |line|
      row = []
      line.chars.each do |c|
        row.push(c)
      end
      temp.push(row)
    end
    
    temp=temp.transpose
    map = []
    temp.each_index do |x|
      row = []
      temp[x].each_index do |y|
        if temp[x][y] == "#"
          if temp[x][y+1] != "#" 
            row.push(1)
          else
            row.push(2)
          end
        elsif temp[x][y] == "."
          if temp[x][y-1] == "#" and temp[x-2][y-1] == "#" and temp [x-1][y-1] !="#"
            row.push(25)
          elsif temp[x][y-1] == "#" and temp[x+2][y-1] == "#" and temp [x+1][y-1] !="#"
            row.push(24)
          elsif temp[x-1][y] == "#" and temp[x+1][y] == "#"
            row.push(21)
          elsif temp[x][y-1] != "#" and temp[x-1][y-1] == "#" and temp [x+1][y-1] =="#" and temp [x-1][y] =="#"
            row.push(22)
          elsif temp[x][y-1] != "#" and temp[x-1][y-1] == "#" and temp [x+1][y-1] =="#" and temp [x+1][y] =="#"
            row.push(23)
          elsif temp[x-1][y] == "#" and temp[x][y-1] == "#"
            row.push(16)
          elsif temp[x+1][y] == "#" and temp[x][y-1] == "#"
            row.push(17)
          elsif temp[x-1][y] == "#" and temp[x-1][y-1] != "#"
            row.push(22)
          elsif temp[x+1][y] == "#" and temp[x+1][y-1] != "#"
            row.push(23)
          elsif temp[x-1][y] == "#"
            row.push(18)
          elsif temp[x+1][y] == "#"
            row.push(19)
          elsif temp[x][y-1] == "#"
            row.push(20)
          elsif temp[x-1][y-1] == "#" and temp[x+1][y-1] != "#"
            row.push(24)
          elsif temp[x+1][y-1] == "#" and temp[x-1][y-1] != "#"
            row.push(25)
          else
            row.push(21)
          end
        else
          a = rand(20)
          if a == 1
            row.push(33)
          elsif a == 2
            row.push(34)
          else
            row.push(32)
          end
        end
      end
      map.push(row)
    end
    map
  end
  
  def switch_world(world)
    if world == :cold
      @tiles = @@cold
      @map = @map_cold
      @obj = @obj_cold
    else
      @tiles = @@hot
      @map = @map_hot
      @obj = @obj_hot
    end
  end
  
  def mouse_over_tile
    [((@win.mouse_x - 2)/(@win.scale_x*8)).to_i, ((@win.mouse_y - 2)/(@win.scale_y*8)).to_i]
  end
  
  def target_hit(target)
    @objects_to_destroy.push([target, Timer.new])
  end
  
  def update
    @win.player.cursor_frame = 0
    @win.player.target = nil
    if @win.world == :hot
      @fires.each do |tile|
        @win.player.cursor_frame = 2 if mouse_over_tile == tile
        @win.player.target = mouse_over_tile if mouse_over_tile == tile
      end
    else
      @barrels.each do |tile|
        @win.player.cursor_frame = 1 if mouse_over_tile == tile
        @win.player.target = mouse_over_tile  if mouse_over_tile == tile
      end
    end
    
    if @key != nil
      if distance(@win.player.x+4, @win.player.y+4, @key[0]*8+4, @key[1]*8+4)/@win.scale_x < 0.5
        @key = nil
        @win.player.has_key = true
      end
    end
    
    @objects_to_destroy.each do |obj|
      if @win.world == :hot
        if obj[1].time > 600
          @obj[obj[0][0]][obj[0][1]] = 6
          @objects_to_destroy.delete(obj)
        elsif obj[1].time > 400
          @obj[obj[0][0]][obj[0][1]] = 5
        elsif obj[1].time > 200
          @obj[obj[0][0]][obj[0][1]] = 4
        else
          @fires.delete(obj[0])
        end
      else
        if obj[1].time > 600
          @obj[obj[0][0]][obj[0][1]] = 19
          @objects_to_destroy.delete(obj)
        elsif obj[1].time > 400
          @obj[obj[0][0]][obj[0][1]] = 18
        elsif obj[1].time > 200
          @obj[obj[0][0]][obj[0][1]] = 17
        else
          @barrels.delete(obj[0])
        end
      end
    end
  end
  
  def self.set_hot(img)
    @@hot = img
  end
  
  def self.set_cold(img)
    @@cold = img
  end
  
  def self.set_extras(img)
    @@extras = img
  end
  
  def draw
    @map.each_index do |x|
      @map[x].each_index do |y|
        @tiles[@map[x][y]].draw(x*8, y*8, 1) if @map[x][y] >= 0
      end
    end
    
    @obj.each_index do |x|
      @obj[x].each_index do |y|
        if @obj[x][y] >= 0
          if @obj[x][y] == 0
            @@extras[@obj[x][y] + ((milliseconds/200)%4)].draw(x*8, y*8, 1)
          else
            @@extras[@obj[x][y]].draw(x*8, y*8, 1)
          end
        end
      end
    end
    
    @@extras[8].draw(@door[0]*8, @door[1]*8, 1)
    
    @@extras[10].draw(@key[0]*8, @key[1]*8, 1) if @key != nil
    @@extras[10].draw(210, 4, 1) if @win.player.has_key
    
    @signs.each do |sign|
      @@extras[9].draw(sign[0]*8, sign[1]*8, 1)
    end
  end
end