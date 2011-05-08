$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require "meme_generator"
 
task :build do
  system "gem build memegen.gemspec"
end
 
task :release => :build do
  system "gem push memegen-#{MemeGenerator::VERSION}.gem"
  system "rm memegen-#{MemeGenerator::VERSION}.gem"
end