require "RMagick"
require "fileutils"

class MemeGenerator
  VERSION = "1.0.9"

  INTERLINE_SPACING_RATIO = 3

  class << self

    # @return [Array<String>] Returns a list of short names for memes
    #   available locally on disk.
    def memes
      meme_paths.keys
    end

    # @return [Hash] Returns a hash of of available memes.  Hash keys are
    #   the short names for the memes and the values are paths to the meme
    #   image on disk.
    def meme_paths
      local_image_path = File.expand_path("~/.memegen")
      base = File.join(File.dirname(__FILE__), "..", "generators")
      files = Dir.glob(["#{base}/*", "#{local_image_path}/*.*"])
      files.inject({}) do |images,path|
        name = path.split('/').last.sub(/\.jpg$/, '')
        images.merge(name => path)
      end
    end

    def generate(path, top, bottom)
      top = (top || '').upcase
      bottom = (bottom || '').upcase

      canvas = Magick::ImageList.new(path)
      image = canvas.first

      draw = Magick::Draw.new
      draw.font = File.join(File.dirname(__FILE__), "..", "fonts", "Impact.ttf")
      draw.font_weight = Magick::BoldWeight

      pointsize = image.columns / 5.0
      stroke_width = pointsize / 30.0
      x_position = image.columns / 2
      y_position = image.rows * 0.15

      # Draw top
      unless top.empty?
        scale, text = scale_text(top)
        bottom_draw = draw.dup
        bottom_draw.annotate(canvas, 0, 0, 0, 0, text) do
          self.interline_spacing = -(pointsize / INTERLINE_SPACING_RATIO) * scale
          self.stroke_antialias(true)
          self.stroke = "black"
          self.fill = "white"
          self.gravity = Magick::NorthGravity
          self.stroke_width = stroke_width * scale
          self.pointsize = pointsize * scale
        end
      end

      # Draw bottom
      unless bottom.empty?
        scale, text = scale_text(bottom)
        bottom_draw = draw.dup
        bottom_draw.annotate(canvas, 0, 0, 0, 0, text) do
          self.interline_spacing = -(pointsize / INTERLINE_SPACING_RATIO) * scale
          self.stroke_antialias(true)
          self.stroke = "black"
          self.fill = "white"
          self.gravity = Magick::SouthGravity
          self.stroke_width = stroke_width * scale
          self.pointsize = pointsize * scale
        end
      end

      output_path = "/tmp/meme-#{Time.now.to_i}.jpeg"
      canvas.write(output_path)
      output_path
    end

    private

    def word_wrap(txt, col = 80)
      txt.gsub(/(.{1,#{col + 4}})(\s+|\Z)/, "\\1\n")
    end

    def scale_text(text)
      text = text.dup
      if text.length < 10
        scale = 1.0
      elsif text.length < 24
        text = word_wrap(text, 10)
        scale = 0.70
      elsif text.length < 48
        text = word_wrap(text, 15)
        scale = 0.5
      else
        text = word_wrap(text, 20)
        scale = 0.4
      end
      [scale, text.strip]
    end
  end
end
