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
    'http://nulayer.com/',
    'http://google.ca/'# ,
    #     'http://facebook.com/',
    #     'http://nulayer.com',
    #     'http://data.crowdreel.com.s3.amazonaws.com/2011/05/17-02/1f55685cc1e9c91d80079a49485c718b1f53d97f.jpg',
    #     'http://data.crowdreel.com.s3.amazonaws.com/2011/05/17-02/54acc4f94b81268982aab94e0d273693962741ab.jpg',
    #     'http://data.crowdreel.com.s3.amazonaws.com/2011/05/17-02/66ca6cb906f1b517cc576477b3d69e155dc21284.jpg',
    #     'http://data.crowdreel.com.s3.amazonaws.com/2011/05/17-02/cfeb066a4f0ba75a2081898a6c750d371aafd7e9.jpg'
  ]
  processed = 0
  
Fiber.new {
  urls.each do |url|
  # url = urls.first
  
    x = nil
    page = nil
    
    Fiber.new {
      puts "START => #{url}"
      page = http_get(url)      
      puts "DONE:"+page.response_header.status.to_s+" from #{url}"
      
      t = nil
      f = Fiber.current
      
      j = Fiber.new {
        # 1. This fiber will execute.. then yield once it setups the async callbacks
        puts "************ 1"
        t = http_get(url).response_header.status
        
        # **** But... we want the code to pause here... and let another fiber go
        # or just block .. like typical sync API
        
        puts "############ #{t}"
        
        f.resume
        
        puts "************ 3"
        # 3. code will resume from here once the callback is done...
        
        # puts "b:"+t.to_s
      }.resume
      
      Fiber.yield
      
      
      puts "************ 2"
      # 2. code will continue here even before the callback returns...? .. we don't want
      # that tho .. if we can figure that out .. then we're golden.. 
      
      
      # NOTE: we will never get the varaibles we need.. with async+fiber .. we have to put
      # the context in blocks .. only way .. we can't return shit either
      # puts ">>>b:"+t.to_s
      
      # j = Fiber.new {
      #   puts "c:"+http_get("http://google.ca/").response_header.status.to_s
      # }.resume
      # 
      # 
      # j = Fiber.new {
      #   puts "d:"+http_get("http://google.ca/").response_header.status.to_s
      # }.resume
      
      # puts "jjjjjjj #{j}"
      
      x = "WOOOOOOOOOT"
      processed += 1
    }.resume

    puts "zzzzzz #{x}"
    puts ">>>>>> #{page}"

    # processed += 1      
    # if processed == urls.length
    #   EM.stop
    # end
  end
}.resume

end



__END__
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
  
  Fiber.yield
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
  
# Fiber.new {
  urls.each do |url|
    Fiber.new {
      puts "START => #{url}"
      page = http_get(url)
      puts "DONE  => #{url}"
      processed += 1
      
      if processed == urls.length
        EM.stop
      end
      
    }.resume
  end
# }.resume

end
