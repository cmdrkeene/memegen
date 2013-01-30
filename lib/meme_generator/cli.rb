require 'meme_generator'

def images
  MemeGenerator.meme_paths.values
end

def usage
  puts 'usage: memegen <image> <top> <bottom> [--list|-l] [--campfire|-c] [--groupme|-g] [--help|-h] [--install-autocomplete]'
  exit 1
end

def list_generators
  names = images.map { |path|
    File.basename(path).gsub(/\..*/, '')
  }.sort

  names.each { |name| puts name }
  exit 0
end

def parse_path(string)
  if string =~ /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/ix
    path = "/tmp/memegen-download-#{Time.now.to_i}"
    `curl "#{string}" -o #{path} --silent`
  elsif path = images.find { |p| p =~ /\/#{string}\..*$/ }
  else
    puts "Error: Image not found. Use --list to view installed images."
    exit 1
  end
  path
end

def generate(path, top, bottom, campfire, groupme)
  if top || bottom
    output_path = MemeGenerator.generate(path, top, bottom)

    if campfire
      MemeGenerator::Campfire.upload(output_path)
    end
    if groupme
      MemeGenerator::GroupMe.upload(output_path)
    end
    if (! (campfire || groupme) )
      puts output_path
    end
    exit 0
  else
    puts "Error: You must provide at least one piece of text"
    usage
  end
end

def install_autocomplete
  path = File.join(File.dirname(__FILE__), "..", "..", "script", "autocomplete.sh")
  puts <<-END
Source autocomplete.sh in your ~/.bashrc:

    $ echo "source #{path}" >> ~/.bashrc

Then source the profile:

    $ source ~/.bashrc
    
Or if you're using a mac

    $ echo "source #{path}" >> ~/.bash_profile
    
and
    $ source ~/.bash_profile

You can copy the path to autocomplete.sh somewhere in your home directory if
you upgrade gem versions, but it should always work.

(Sorry, this sucks but I don't know a foolproof way to do this)
END
  exit 0
end
