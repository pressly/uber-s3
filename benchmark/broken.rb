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

NUM_FILES  = 50
DATA_SIZE  = 1024*100 # in bytes


NUM_FIBERS = 10
require 'fiber_pool'
@fiber_pool = FiberPool.new(NUM_FIBERS)


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
save_object_bm = Proc.new do |client,async|
  @processed = 0
  
  files.each do |filename|
    work = Proc.new do
      $stderr.puts "START => #{filename}"
      ret = client.store(filename, data)
      $stderr.puts "DONE  => #{filename}"
      $stderr.puts "Error storing file #{filename}" if !ret
      @processed += 1
      EM.stop if async && @processed == NUM_FILES
    end
    
    if async
      @fiber_pool.spawn(&work)
      # Fiber.new { work.call }.resume
    else
      work.call
    end
  end
end


## Clients --------------------------------------------------------------------

s3 = {}.tap do |clients|
  [:net_http, :em_http_sync].each do |mode|
    clients[mode] = UberS3.new({
      :access_key         => SETTINGS['access_key'],
      :secret_access_key  => SETTINGS['secret_access_key'],
      :bucket             => SETTINGS['bucket'],
      :persistent         => true,
      :adapter            => mode
    })
  end
end


## Let's run this thing -------------------------------------------------------

Benchmark.bm do |bm|
  # bm.report("saving #{NUM_FILES}x#{DATA_SIZE} byte objects (net-http)") do
  #   save_object_bm.call(s3[:net_http], false)
  # end

  bm.report("saving #{NUM_FILES}x#{DATA_SIZE} byte objects (em-http-sync)") do
    EM.run do
      save_object_bm.call(s3[:em_http_sync], true)
    end
  end
end
