require 'rmagick'
require 'chunky_png'

class AsciiImageConverter
  ASCII_CHARS = "Ñ@#W$9876543210?!abc;:+=-,._ ".split('')

  def initialize(image_path, text_path, scale_factor = 1)
    image = ChunkyPNG::Image.from_file(image_path)
    @image = image.resample_bilinear((image.width * scale_factor).round, (image.height * scale_factor).round)
    @text_path = text_path
    @start_index = 0
  end

  def convert_to_ascii
    ascii_image = ""
    (0...@image.height).step(2) do |y|
      (0...@image.width).each do |x|
        r, g, b = ChunkyPNG::Color.to_truecolor_bytes(@image[x, y])
        gray = (r + g + b) / 3.0
        ascii_image += map_grayscale_to_ascii(gray)
        @start_index += 1
      end
      ascii_image += "\n"
    end
  
    draw = Magick::Draw.new
    draw.font = 'Courier'
    draw.pointsize = 12

    image_width = ascii_image.split("\n").map(&:length).max * 12
    image_height = ascii_image.count("\n") * 12
  
    image = Magick::Image.new(image_width, image_height)
    draw.annotate(image, 0, 0, 0, 0, ascii_image)
  
    image.write(@text_path.sub('.txt', '_ascii.png'))
  end

  private

  def map_grayscale_to_ascii(gray)
    index = ((gray / 255.0)**0.5 * (ASCII_CHARS.length - 1)).round
    ASCII_CHARS[index]
  end
end

converter = AsciiImageConverter.new('luna.png', 'luna.txt', 1)
converter.convert_to_ascii