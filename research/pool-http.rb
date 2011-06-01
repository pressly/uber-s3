require 'eventmachine'
require 'em-http'
require 'em-synchrony'
require 'em-synchrony/em-http'

require 'ruby-debug'

CONCURRENCY = 10

EM.run do
  pool = EM::Synchrony::ConnectionPool.new(:size => CONCURRENCY) do
    EM::HttpRequest.new('http://www.google.ca/')
  end
  
  p = { :keepalive => true }
  num = 40
  counter = num

  num.times do
    Fiber.new {
      x = pool.get(p)
      puts "GOT IT #{x.response.length}"
      counter -= 1
      
      EM.stop if counter <= 0
    }.resume
  end

end
