require 'dxruby'
require_relative 'Chara.rb'


pl=Player.new
Window.loop do
    
    pl.all

    break if Input.key_push?(K_ESCAPE)
end