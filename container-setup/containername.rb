require 'yaml'

def container_name
  yaml = YAML.load_file("docker-compose.yml")

  project_name = File.basename Dir.pwd
  container = yaml["services"].keys.first

  "#{project_name}-#{container}-1"
rescue e
  STDERR.puts e.message
  nil
end
