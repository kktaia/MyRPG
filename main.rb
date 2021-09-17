require 'dxruby'
require_relative 'Chara'
require_relative 'Map'


pl = Player.new
map = Map.new

Window.loop do

  Sprite.update([pl, map])

  break if Input.key_push?(K_ESCAPE)
end
