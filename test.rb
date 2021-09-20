require 'csv'
require 'dxruby'
require 'active_support'
# encoding: utf-8

bgr_s = []
x = 0
y = 0
54.step(File.size('world_map.bmp') - 3, 3) do |offset|
  #print "(#{x},#{y})" if x % 10 == 0 && y % 10 == 0
  bgr = {}
  #bgr[:b] = File.binread('world_map.bmp', 1, offset).unpack("C*")[0]
  #bgr[:g] = File.binread('world_map.bmp', 1, offset + 1).unpack("C*")[0]
  #bgr[:r] = File.binread('world_map.bmp', 1, offset + 2).unpack("C*")[0]
  #p bgr if x % 10 == 0 && y % 10 == 0
  x += 1
  if x == 100
    x = 0
    y += 1
  end
  bgr_s << bgr
end

a = { ab: 10, cd: 20, ef: 30 }


p *(a.values)