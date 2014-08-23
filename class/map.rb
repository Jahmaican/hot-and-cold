class Map
  @@hot = nil
  @@cold = nil
  # size 42/24
  def initialize(win)
    @@hot = Image.load_tiles(win, "media/maphot.png", 8, 8, true)
    @@cold = Image.load_tiles(win, "media/mapcold.png", 8, 8, true)
    @tiles = @@cold
    
    @map = load_map("media/level1.map")
    
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
          elsif temp[x-1][y-1] == "#"
            row.push(24)
          elsif temp[x+1][y-1] == "#"
            row.push(25)
          else
            row.push(21)
          end
        else
          row.push(-1)
        end
      end
      map.push(row)
    end
    map
  end
  
  def switch_world(world)
    @tiles = world == :cold ? @@hot : @@cold
  end
  
  def update
    
  end
  
  def draw
    @map.each_index do |x|
      @map[x].each_index do |y|
        @tiles[@map[x][y]].draw(x*8, y*8, 1) if @map[x][y] >= 0
      end
    end
  end
end