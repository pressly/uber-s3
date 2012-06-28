$:.unshift "."
$:.unshift "../../lib"

require 'bundler'
Bundler.setup

require 'ruby-debug'
require 'eventmachine'
require 'em-http'
require 'em-synchrony'
require 'em-synchrony/em-http'

# require 'fiber_pool'
require 'uber-s3'

CONCURRENCY_LEVEL = 3

# ************* Main issue:
# At a pool size of 50 or above .. this thing will crash within 15 seconds
# .. but at pool of 10 .. it will keep going and going..
# no idea why .. perhaps my connection is tapped, and the queue increases
# or file descriptor limit.. etc. eventually the EM deferred_status will
# be :failed
# @fiber_pool = FiberPool.new(CONCURRENCY_LEVEL)


EM.run do

  s3 = UberS3.new({
    :access_key         => 'x',
    :secret_access_key  => 'y',
    :bucket             => 'data.crowdreel.com',
    :adapter            => :em_http_fibered
  })
  
  @num = 0
  @start = Time.now

  trap(:INT) do
    finish = Time.now
    puts "I'm outta here -- #{@num} -- #{finish - @start}"
    exit
  end

  Fiber.new {

    # Grab up to 100 objects
    list = []
    s3.objects('/').each do |obj|      
      list << obj
      break if list.length > 100
    end
    
    puts "OKAYYYYYYYY..."
    
    # --
    running = 0
    counter = 0

    f = Fiber.new {
    list.each do |obj|

      puts counter
      
      if running >= CONCURRENCY_LEVEL
        x = Fiber.yield
        puts "RESUME: #{x}"
      end
      
      if running < CONCURRENCY_LEVEL
        ret = Fiber.new {
          running += 1
      
          x = obj.bucket.connection.head(obj.key)
      
          if x.status == 0
            puts "ERROR: we got 0 status.. weird.. here's the raw response"
            # For more details, throw a debugger in here and look at x.raw closer
            puts x.raw.inspect
            exit
          end
      
          puts obj.to_s + " -- #{x.status}"
      
          @num += 1 if x
          running -= 1
        
          # if running < CONCURRENCY_LEVEL
          #   f.resume("hiiiiiiiiiiiiiii")
          # end
        
          "done"
        }.resume
        
        puts "RET: #{ret}"
      end
      
      counter += 1
    end
    }.resume
    
  }.resume

end

