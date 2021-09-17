require 'dxruby'
FONT = Font.new(20)
CELL_WIDTH = 40
CELL_HEIGHT = 40
CELL_NUM_X = 21
CELL_NUM_Y = 17
Window.width = 720
Window.height = 480
WALKTIME = 15

class Sprite
  attr_accessor :width, :height
  alias init_origin initialize

  def initialize(x = 0, y = 0, image = nil)
    init_origin(x, y, image)
    @width = image.width if !image.nil?
    @height = image.height if !image.nil?
    self.x *= CELL_WIDTH
    self.y *= CELL_HEIGHT
  end
end