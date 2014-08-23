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
    
    map = []
    temp.each do |line|
      row = []
      line.each_index do |c|
        if line[c] == "#"
          row.push(2)
        elsif line[c] == "."
          row.push(8)
        else
          row.push(-1)
        end
      end
      map.push(row)
    end
    map = map.transpose
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