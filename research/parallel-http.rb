require 'bundler'
Bundler.setup

require 'eventmachine'
require 'em-http-request'
require 'fiber'


def http_get(url)
  f = Fiber.current
  
  req = EM::HttpRequest.new(url).get
  req.callback { f.resume(req) }
  req.errback  { f.resume(req) }
  
  return Fiber.yield
end

EM.run do
  
  urls = [
    'http://nulayer.com/',
    'http://google.ca/',
    'http://facebook.com/',
    'http://nulayer.com',
    'http://data.crowdreel.com.s3.amazonaws.com/2011/05/17-02/1f55685cc1e9c91d80079a49485c718b1f53d97f.jpg',
    'http://data.crowdreel.com.s3.amazonaws.com/2011/05/17-02/54acc4f94b81268982aab94e0d273693962741ab.jpg',
    'http://data.crowdreel.com.s3.amazonaws.com/2011/05/17-02/66ca6cb906f1b517cc576477b3d69e155dc21284.jpg',
    'http://data.crowdreel.com.s3.amazonaws.com/2011/05/17-02/cfeb066a4f0ba75a2081898a6c750d371aafd7e9.jpg'
  ]
  processed = 0
  
Fiber.new {
  urls.each do |url|
    # Fiber.new {
      puts "START => #{url}"
      page = http_get(url)
      puts "DONE  => #{url}"
      processed += 1
      
      if processed == urls.length
        EM.stop
      end
      
    # }.resume
  end
}.resume

end
