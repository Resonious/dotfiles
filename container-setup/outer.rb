dir = File.dirname(File.expand_path(__FILE__))
require File.join(dir, "containername.rb")

c = container_name || ARGV[0]

if c.nil?
  STDERR.puts "Pass container name as first argument."
  exit 1
end

dir = File.dirname(File.expand_path(__FILE__))

result = system 'podman', 'cp', File.join(dir, "inner.sh"), "#{c}:/nigelsetup.sh"
exit 2 unless result

result = system 'podman', 'exec', '--user=root', '-it', c, 'sh', '/nigelsetup.sh'
exit 2 unless result
