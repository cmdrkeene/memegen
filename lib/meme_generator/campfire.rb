class MemeGenerator
  class Campfire
    CONFIG_PATH = File.join(File.expand_path("~/.memegen"), ".campfire")

    class << self
      def config
        return unless File.exists?(CONFIG_PATH)
        @config ||= read_config
      end

      def prompt_config
        puts "Set your Campfire credentials..."
        print "Subdomain : "
        subdomain = gets.strip
        print "Token     : "
        token = gets.strip
        print "Room      : "
        room = gets.strip

        write_config([subdomain, token, room])

        puts "Config saved successfully!"
      end

      def upload(path)
        require 'tinder'
        require 'open-uri'

        puts "Uploading... "
        silence_stream(STDERR) do
          campfire = Tinder::Campfire.new config[:subdomain], :token => config[:token]
          room = campfire.rooms.detect { |room| room.name == config[:room] }
          room.upload(path)
        end
      end

      private

      def silence_stream(stream)
        old_stream = stream.dup
        stream.reopen(RbConfig::CONFIG['host_os'] =~ /mswin|mingw/ ? 'NUL:' : '/dev/null')
        stream.sync = true
        yield
      ensure
        stream.reopen(old_stream)
      end

      # Lame format is to keep dependencies at a minimum
      def read_config
        data = File.read(CONFIG_PATH)
        values = data.split("|")
        {
          :subdomain  => values[0],
          :token      => values[1],
          :room       => values[2]
        }
      end

      def write_config(config)
        File.open(CONFIG_PATH, "w") do |file|
          file.write(config.join("|"))
        end
      end
    end
  end
end
