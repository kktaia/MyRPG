require 'dxruby'
require_relative 'define'
require_relative 'Map'
require_relative 'Chara'

class Control
  attr_accessor :pl, :map

  def initialize
    @pl = Player.new
    @map = [
      Map.new('csv/flame1.csv'),
      Map.new('csv/flame2.csv'),
      Map.new('csv/flame3.csv')
    ]
    pl.x = pl.target_x = CELL_WIDTH
    pl.y = pl.target_y = CELL_HEIGHT
  end

  def update
    pl.update(map)
    Sprite.update(map)
  end
end