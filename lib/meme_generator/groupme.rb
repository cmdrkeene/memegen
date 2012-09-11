require 'net/http/post/multipart'
require 'net/http'
require 'net/https'
require 'json'

class MemeGenerator
  class GroupMe
    MEMEGEN_PATH = File.expand_path("~/.memegen")
    CONFIG_PATH = File.join(MEMEGEN_PATH, ".groupme")

    class << self
      def config
        return unless File.exists?(CONFIG_PATH)
        @config ||= read_config
      end

      def prompt_config
        require "readline"
        require "highline/import"
        puts "Set your GroupMe credentials..." unless config

        phonenumber     = Readline.readline("Phone #: ").strip
        password = ask("Password: ")  { |input| input.echo = false }
        room      = Readline.readline("Group Id: ").strip
        message   = Readline.readline("Message (optional): ").strip
        
        token = auth_user(phonenumber, password)
        
        if (token == nil)
          puts "Error authorizing user"
        else
          write_config([token, room, message])
          puts "Config saved successfully!"
        end
      end
      
      def auth_user(phonenumber, password)
        groupme_url = "https://v2.groupme.com/access_tokens"
        uri = URI.parse(groupme_url)
        request = Net::HTTP::Post.new(uri.request_uri)
        request.set_form_data({"grant_type" => "password", "phone_number" => phonenumber, "password" => password, "app_id" => "memegen"});
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        response = http.request(request)
        json_res = JSON.parse(response.body)
        token = json_res["response"]["access_token"]
        return token
      end

      def upload(path)
        prompt_config unless config

        puts "Uploading... "
        silence_stream(STDERR) do
        
          url = URI.parse('http://groupme-image-service.heroku.com/images');
          File.open(path) do |jpg|
            req = Net::HTTP::Post::Multipart.new url.path, "file" => UploadIO.new(jpg, "image/jpeg", "file.jpg")
            res = Net::HTTP.start(url.host, url.port) do |http|
                http.request(req)
            end
            json_res = JSON.parse(res.body)
            img_url = json_res['payload']['picture_url']
          
            groupme_url = "https://v2.groupme.com/groups/#{config[:room]}/messages?app_id=memgen&token=#{config[:token]}"
          
            msg_json = {'message' => {'text' => config[:message], 'picture_url' => img_url}}.to_json
          
            puts "Posting Message..."
          
            url = URI.parse(groupme_url)
            req = Net::HTTP::Post.new url.request_uri
            req.body = msg_json.to_s
            req['Content-Type'] = "text/json"
            http = Net::HTTP.new(url.host, url.port)
            http.use_ssl = true
            http.request(req)
          
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
          :token      => values[0],
          :room       => values[1],
          :message    => values[2]
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
