require 'dxruby'
require_relative 'define'
require_relative 'Map'
require_relative 'Chara'
require_relative 'WindowBox'

class Control
  attr_accessor :pl, :map, :msg

  def initialize
    @pl = Player.new
    @map = [
      Map.new('csv/flame1.csv'),
      Map.new('csv/flame2.csv'),
      Map.new('csv/flame3.csv')
    ]
    @msg = MessageWindow.new('txt/立札.txt')
    msg.reset
    pl.x = pl.target_x = CELL_WIDTH
    pl.y = pl.target_y = CELL_HEIGHT
  end

  def update
    pl.update(map)
    Sprite.update([map, msg])
  end
end