def images
  local_image_path = File.expand_path("~/.memegen")
  Dir.glob(["#{File.expand_path("generators")}/*", "#{local_image_path}/*."])
end

def usage
  puts 'usage: memegen <image> <top> <bottom> [--list|-l] [--campfire|-c] [--help|-h]'
  exit 1
end

def list_generators
  names = images.map { |path|
    File.basename(path).gsub(/\..*/, '')
  }.sort

  names.each { |name| puts name }
  exit 0
end

def setup_campfire
  require "meme_generator/campfire"
  if !MemeGenerator::Campfire.config
    MemeGenerator::Campfire.prompt_config
  end
end

def parse_path(string)
  if string =~ /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/ix
    path = "/tmp/memegen-download-#{Time.now.to_i}"
    `curl "#{image}" -o #{path} --silent`
  elsif path = images.find { |p| p =~ /#{path}\./ }
  else
    puts "Error: Image not found. Use --list to view installed images."
    exit 1
  end
  path
end

def generate(path, top, bottom, campfire)
  if top || bottom
    require "meme_generator"
    output_path = MemeGenerator.generate(path, top, bottom)

    if campfire
      MemeGenerator::Campfire.upload(output_path)
    else
      puts output_path
    end
    exit 0
  else
    puts "Error: You must provide at least one piece of text"
    usage
  end
end
