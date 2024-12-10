require 'yaml'

def container_name
  yaml = YAML.load_file("docker-compose.yml")

  project_name = File.basename Dir.pwd
  container = yaml["services"].keys.first

  "#{project_name}_#{container}_1"
rescue Errno::ENOENT => _
  STDERR.puts "No docker-compose.yml found in #{Dir.pwd}"
  nil
rescue => e
  STDERR.puts e.message
  nil
end
