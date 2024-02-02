require 'ruby2d'

class Snowflake
  attr_accessor :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end
end

class Snowfall
  attr_accessor :snowflakes, :cols, :rows, :w, :grid

  def initialize
    @w = 5
    @cols = Window.width / @w
    @rows = Window.height / @w
    @snowflakes = []
    @grid = Array.new(@cols) { Array.new(@rows, false) }
  end

  def add_snowflake(snowflake)
    @snowflakes << snowflake
    @grid[snowflake.x][snowflake.y] = true
  end

  def update
    # Update the position of each snowflake
    @snowflakes.each do |snowflake|
      if snowflake.y < @rows - 1 && !@grid[snowflake.x][snowflake.y + 1]
        @grid[snowflake.x][snowflake.y] = false
        snowflake.y += 1
        @grid[snowflake.x][snowflake.y] = true
      end
    end
  end

  def draw
    # Draw each snowflake
    @snowflakes.each do |snowflake|
      Square.new(x: snowflake.x * @w, y: snowflake.y * @w, size: @w, color: 'white')
    end
  end
end

snowfall = Snowfall.new

update do
  # Add a new snowflake at a random position at the top of the window
  if rand < 0.9 && snowfall.snowflakes.size < snowfall.cols * snowfall.rows * 0.2
    snowfall.add_snowflake(Snowflake.new(rand(snowfall.cols), 0))
  end

  snowfall.update
  clear
  snowfall.draw
end

on :mouse_down do |event|
  # Add a new snowflake at the position of the mouse cursor
  col = event.x / snowfall.w
  snowfall.add_snowflake(Snowflake.new(col, 0)) if col.between?(0, snowfall.cols - 1)
end

show