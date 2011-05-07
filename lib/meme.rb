require "rubygems"
require "RMagick"

class Meme
  class << self
    def run(argv = ARGV)
      generator, top, bottom = argv[0..2]
      if path = Dir.glob("images/#{generator}*").first
        generate(path, top, bottom)
        exit 0
      else
        puts "Meme not found"
        exit 1
      end
    end
    
    private
    
    def generate(path, top, bottom)
      top = top.upcase
      bottom = bottom.upcase
      
      canvas = Magick::ImageList.new(path)
      image = canvas.first
      
      draw = Magick::Draw.new
      draw.font = "/Library/Fonts/Impact.ttf"
      draw.font_weight = Magick::BoldWeight
      
      pointsize = image.columns / 5.0
      stroke_width = pointsize / 25.0
      x_position = image.columns / 2
      y_position = image.rows * 0.15
      draw.interline_spacing(-(pointsize / 5))
      
      # Draw top
      scale, text = scale_text(top)
      bottom_draw = draw.dup
      bottom_draw.annotate(canvas, 0, 0, 0, 0, text) do
        self.stroke_antialias(true)
        self.stroke = "black"
        self.fill = "white"
        self.gravity = Magick::NorthGravity
        self.stroke_width = stroke_width * scale
        self.pointsize = pointsize * scale
      end
      
      # Draw bottom
      scale, text = scale_text(bottom)
      bottom_draw = draw.dup
      bottom_draw.annotate(canvas, 0, 0, 0, 0, text) do
        self.stroke_antialias(true)
        self.stroke = "black"
        self.fill = "white"
        self.gravity = Magick::SouthGravity
        self.stroke_width = stroke_width * scale
        self.pointsize = pointsize * scale
      end
  
      output_path = "tmp/meme.jpeg"
      canvas.write(output_path)
      puts output_path
      exit 0
    end
    
    def word_wrap(txt, col = 80)
      txt.gsub(/(.{1,#{col + 4}})(\s+|\Z)/, "\\1\n")
    end
    
    def scale_text(text)
      text = text.dup
      if text.length < 10
        scale = 1.0
      elsif text.length < 24
        text = word_wrap(text, 10)
        scale = 0.75
      else
        text = word_wrap(text, 18)
        scale = 0.5
      end
      [scale, text.strip]
    end
  end
end