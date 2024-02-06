require 'chunky_png'

class AsciiImageConverter
    ASCII_CHARS = "Ñ@#W$9876543210?!abc;:+=-,._ ".split('').reverse

  def initialize(image_path, text_path, scale_factor = 0.1)
    image = ChunkyPNG::Image.from_file(image_path)
    @image = image.resample_nearest_neighbor((image.width * scale_factor).round, (image.height * scale_factor).round)
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
    File.open(@text_path, 'w') { |file| file.write(ascii_image) }
  end

  private

  def map_grayscale_to_ascii(gray)
    index = (gray / 255.0 * (ASCII_CHARS.length - 1)).round
    ASCII_CHARS[index]
  end
end

converter = AsciiImageConverter.new('luna.png', 'luna.txt', 0.1)
converter.convert_to_ascii