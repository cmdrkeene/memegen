require "tinder"

class MemeGenerator
  class Campfire
    MEMEGEN_PATH = File.expand_path("~/.memegen")
    CONFIG_PATH = File.join(MEMEGEN_PATH, ".campfire")

    class << self
      def config
        return unless File.exists?(CONFIG_PATH)
        @config ||= read_config
      end

      def prompt_config
        require "readline"
        puts "Set your Campfire credentials..." unless config

        subdomain = Readline.readline("Subdomain : ").strip
        token     = Readline.readline("Token     : ").strip
        room      = Readline.readline("Room      : ").strip

        write_config([subdomain, token, room])

        puts "Config saved successfully!"
      end

      def upload(path)
        prompt_config unless config

        puts "Uploading... "
        silence_stream(STDERR) do
          begin
            campfire = Tinder::Campfire.new config[:subdomain], :token => config[:token]
            room = campfire.rooms.detect { |room| room.name == config[:room] }
            room.upload(path)
          rescue Tinder::AuthenticationFailed
            puts "Your campfire credentials are incorrect. Please enter them again."
            prompt_config
            upload(path)
          end
        end
        puts "Done!"
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
        FileUtils.mkdir_p(MEMEGEN_PATH)
        File.open(CONFIG_PATH, "w") do |file|
          file.write(config.join("|"))
        end
      end
    end
  end
end
