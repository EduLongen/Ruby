require 'ruby2d'

class PolygonWindow
  attr_accessor :scale_factor
  def initialize(vertices, scale_factor)
    @vertices = vertices
    @scale_factor = scale_factor
    @centroid = calculate_centroid
  end
  def draw
    draw_grid
    draw_polygon
    draw_centroid
    draw_scale_factor
    draw_vertices
    draw_centroid_value
  end

  private

  def draw_grid
    (-360..360).step(scale_factor) do |x|
      Line.new(x1: x * scale_factor + 360, y1: 0, x2: x * scale_factor + 360, y2: 720, width: 1, color: 'silver')
      Text.new(x.to_s, x: x * scale_factor + 360, y: 360, size: 10, color: 'black')
    end
    (-360..360).step(scale_factor) do |y|
      Line.new(x1: 0, y1: 720 - y * scale_factor - 360, x2: 720, y2: 720 - y * scale_factor - 360, width: 1, color: 'silver')
      Text.new(y.to_s, x: 360, y: 720 - y * scale_factor - 360, size: 10, color: 'black')
    end
    Text.new('X', x: 700, y: 360, size: 20, color: 'black')
    Text.new('Y', x: 360, y: 20, size: 20, color: 'black')
  end

  def draw_polygon
    @vertices.each_cons(2) do |(x1, y1), (x2, y2)|
      Line.new(x1: (x1 * @scale_factor) + 360, y1: 720 - (y1 * @scale_factor) - 360, x2: (x2 * @scale_factor) + 360, y2: 720 - (y2 * @scale_factor) - 360, color: 'green')
    end
    Line.new(x1: (@vertices.first[0] * @scale_factor) + 360, y1: 720 - (@vertices.first[1] * @scale_factor) - 360, x2: (@vertices.last[0] * @scale_factor) + 360, y2: 720 - (@vertices.last[1] * @scale_factor) - 360, color: 'green')
  end

  def draw_centroid
    x, y = @centroid
    Square.new(x: (x * @scale_factor) + 360 - 2, y: 720 - (y * @scale_factor) - 360 - 2, size: 2, color: 'red')
  end

  def calculate_centroid
    x, y = 0.0, 0.0
    n = @vertices.length
    signed_area = 0.0
    (0...n).each do |i|
      x0, y0 = @vertices[i]
      x1, y1 = @vertices[(i + 1) % n]
      # Shoelace formula
      area = (x0 * y1) - (x1 * y0)
      signed_area += area
      x += (x0 + x1) * area
      y += (y0 + y1) * area
    end
    signed_area *= 0.5
    x /= (6.0 * signed_area)
    y /= (6.0 * signed_area)
    [x, y]
  end

  def draw_vertices
    @vertices.each_with_index do |(x, y), index|
      Text.new("V#{index + 1}: (#{x}, #{y})", x: 10, y: 10 + index * 20, size: 20, color: 'black')
    end
  end
  
  def draw_centroid_value
    x, y = @centroid
    Text.new("Centroid: (#{x.round(4)}, #{y.round(4)})", x: 10, y: 10 + @vertices.size * 20, size: 20, color: 'black')
  end

  def draw_scale_factor
    Text.new("Scale: #{@scale_factor}", x: 600, y: 10, size: 20, color: 'black')
  end

end

set title: "Polygon Centroid", width: 720, height: 720, background: 'white'
set width: 720, height: 720

puts "Enter vertices coordinates separated by a space (e.g., 'x1 y1 x2 y2 x3 y3'):"
input = gets.chomp
vertices = input.split.each_slice(2).map { |x, y| [x.to_f, y.to_f] }

scale_factor = vertices.flatten.max
polygon_window = PolygonWindow.new(vertices, scale_factor)

on :key_down do |event|
  case event.key
  when 'up'
    polygon_window.scale_factor += 1
  when 'down'
    polygon_window.scale_factor -= 1 if polygon_window.scale_factor > 1
  end
end

update do
  clear
  polygon_window.draw
end

show