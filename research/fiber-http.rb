require 'bundler'
Bundler.setup

require 'ruby-debug'
require 'eventmachine'
require 'em-http-request'
require 'fiber'


def http_get(url)
  f = Fiber.current
  
  req = EM::HttpRequest.new(url).get
  req.callback { f.resume(req) }
  req.errback  { f.resume(req) }
  
  Fiber.yield
end

EM.run do
  urls = [
    ['http://nulayer.com/', 'http://twitter.com/#!/nupeter/'],
    ['http://google.ca/', 'http://twitter.com/#!/jeffbrenner/'],
    ['http://facebook.com/', 'http://twitter.com/#!/nulayer/'],
    ['http://data.crowdreel.com.s3.amazonaws.com/2011/05/17-02/1f55685cc1e9c91d80079a49485c718b1f53d97f.jpg', 'http://twitter.com/#!/jack/'],
    ['http://data.crowdreel.com.s3.amazonaws.com/2011/05/17-02/54acc4f94b81268982aab94e0d273693962741ab.jpg', 'http://twitter.com/#!/ev/'],
    ['http://data.crowdreel.com.s3.amazonaws.com/2011/05/17-02/66ca6cb906f1b517cc576477b3d69e155dc21284.jpg', 'http://twitter.com/#!/presslyapp/'],
    ['http://data.crowdreel.com.s3.amazonaws.com/2011/05/17-02/cfeb066a4f0ba75a2081898a6c750d371aafd7e9.jpg', 'http://twitter.com/#!/crpwdreel/']
  ]
  
  puts "init"
  
  Fiber.new {
    # url = 'http://nulayer.com/'
    # ret = http_get(url)
    # puts ret.response_header.status.to_s+" from #{url}"
    
    urls.each do |url|
      Fiber.new {
        puts "A start: #{url[0]}"
        ret = http_get(url[0])
        puts "A done:  #{url[0]} -- #{ret.response_header.status.to_s}"
        
        Fiber.new {
          puts "B start: #{url[1]}"
          ret = http_get(url[0])
          puts "B done:  #{url[1]} -- #{ret.response_header.status.to_s}"
        }.resume
      }.resume
    end
  }.resume
  
  puts "eof"
end
