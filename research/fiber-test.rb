require 'fiber'

def woot
  x = nil
  
  f = Fiber.new { |k|
    puts k
    y = Fiber.yield 1
    puts y
    x = "hello"
    2
  }
  
  puts f.resume(5)
  puts f.resume(6)
  puts x
  
end

woot
