begin
  require 'bundler'
  Bundler.setup(:default, :test)
rescue LoadError => e
  # Fall back on doing an unlocked resolve at runtime.
  $stderr.puts e.message
  $stderr.puts "Try running `bundle install`"
  exit!
end

$:.unshift(File.dirname(__FILE__))
$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
UBERS3_ROOT = File.expand_path('../../', __FILE__)
SETTINGS = YAML.load(File.read("#{UBERS3_ROOT}/spec/config/settings.yml"))['test']

# begin
#   require 'ruby-debug'
# rescue LoadError
# end

require 'uber-s3'
require 'benchmark'

NUM_FILES  = 100
DATA_SIZE  = 1048 # in bytes


## Prepare files and data -----------------------------------------------------

require 'digest/md5'

# Prepare files and data
files = []
NUM_FILES.times do
  files << "/benchmark/"+Digest::MD5.hexdigest(rand.to_s)
end

data = (1..DATA_SIZE).map{|i| ('a'..'z').to_a[rand(26)]}.join


## Bench cases ----------------------------------------------------------------

# Saving objects
save_object_bm = Proc.new do |client|
  files.each do |filename|
    $stderr.puts filename
    ret = client.store(filename, data)
    $stderr.puts "Error storing file #{filename}" if !ret
  end
end


## Clients --------------------------------------------------------------------

s3 = {}.tap do |clients|
  # [:net_http, :em_http_fibered].each do |mode|
  [:net_http].each do |mode|
    clients[mode] = UberS3.new({
      :access_key         => SETTINGS['access_key'],
      :secret_access_key  => SETTINGS['secret_access_key'],
      :bucket             => SETTINGS['bucket'],
      :adapter            => mode
    })
  end
end


## Let's run this thing -------------------------------------------------------

puts "UberS3 v#{UberS3::VERSION}"

Benchmark.bm do |bm|
  bm.report("saving #{NUM_FILES}x#{DATA_SIZE} byte objects (net-http) ") do
    save_object_bm.call(s3[:net_http])
  end

  # bm.report("saving #{NUM_FILES}x#{DATA_SIZE} byte objects (em-http-fibered) ") do
  #   EM.run do
  #     Fiber.new {
  #       # EM.add_periodic_timer(1) { $stderr.puts "hi" }
  #       save_object_bm.call(s3[:em_http_fibered])
  #     
  #       EM.stop
  #     }.resume
  #   end
  # end
end

__END__

Running this shows that em-http-request is double the speed for small files.
Unfortunately this example still doesn't show the benefits of async concurrency.
Still more work to do ... but the results should be amazing.

      user     system      total        real
saving 50x1024 byte objects (net-http)  0.080000   0.040000   0.120000 ( 20.096848)
saving 50x1024 byte objects (em-http-sync)  0.080000   0.030000   0.110000 ( 10.222595)
