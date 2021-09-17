require 'dxruby'
require_relative 'Control'

cont = Control.new

Window.loop do

  cont.update

  break if Input.key_push?(K_ESCAPE)
end
