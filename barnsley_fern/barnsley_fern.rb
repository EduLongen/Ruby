require 'ruby2d'

class Canvas
  attr_reader :height, :width, :margin

  def initialize
    @height = 360
    @width = 640
    @margin = 10
  end
end

class Point
  attr_accessor :x, :y

  def initialize(x = 0, y = 0)
    @x = x
    @y = y
  end

  def next_point
    r = rand

    if r < 0.01
      @y = 0.16 * @y
      @x = 0
    elsif r < 0.86
      @x, @y = 0.85 * @x + 0.04 * @y, -0.04 * @x + 0.85 * @y + 1.6
    elsif r < 0.93
      @x, @y = 0.2 * @x + -0.26 * @y, 0.23 * @x + 0.22 * @y + 1.6
    else
      @x, @y = -0.15 * @x + 0.28 * @y, 0.26 * @x + 0.24 * @y + 0.44
    end
  end
end

class BarnsleyFern
  attr_reader :canvas, :point

  def initialize(canvas)
    @canvas = canvas
    @point = Point.new
  end

  def map_range(value, from_min, from_max, to_min, to_max)
    (value - from_min) * (to_max - to_min) / (from_max - from_min) + to_min
  end

  def draw_point
    Square.new(
      x: map_range(@point.x, -2.182, 2.6558, 0, @canvas.width),
      y: map_range(@point.y, 0, 9.9983, @canvas.height, 0),
      size: 1,
      color: '#588157'
    )
  end
end

canvas = Canvas.new
set width: canvas.width, height: canvas.height

fern = BarnsleyFern.new(canvas)

update do
  500.times do
    fern.draw_point
    fern.point.next_point
  end
end

show