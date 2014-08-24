class Map
  attr_reader :map, :spawn_x, :spawn_y
  
  @@hot = nil
  @@cold = nil
  @@extras = nil
  # size 42/24
  
  def initialize(win, level)
    @tiles = @@cold
    
    @spawn_x, @spawn_y = 0, 0
    
    @map_hot = load_map("levels/" + level + "/" + level + "hot.map")
    @map_cold = load_map("levels/" + level + "/" + level + "cold.map")
    @map = @map_cold
    
    @obj_hot = load_obj("levels/" + level + "/" + level + "hot.obj")
    @obj_cold = load_obj("levels/" + level + "/" + level + "cold.obj")
    @obj = @obj_cold
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
        if temp[x][y] == "1"
          @spawn_x = x*8
          @spawn_y = y*8
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
      @tiles = @@hot
      @map = @map_hot
    else
      @tiles = @@cold
      @map = @map_cold
    end
  end
  
  def update
    
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
  end
end