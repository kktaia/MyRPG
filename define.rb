require 'dxruby'
FONT = Font.new(20)
CELL_WIDTH = 40
CELL_HEIGHT = 40
CELL_NUM_X = 21
CELL_NUM_Y = 17
CELL_NUM_WX = 100
CELL_NUM_WY = 100
Window.width = 720
Window.height = 480
WALKTIME = 15
$state = :NONE
$location = :TOWN

class Sprite
  attr_accessor :width, :height
  alias init_origin initialize

  def initialize(x = 0, y = 0, image = nil)
    init_origin(x, y, image)
    @width = image.width if !image.nil?
    @height = image.height if !image.nil?
    self.scale_x = CELL_WIDTH / width.to_f
    self.scale_y = CELL_HEIGHT / height.to_f
    self.center_x = 0
    self.center_y = 0
  end
end

module Window
  def self.draw_extend(x1, y1, x2, y2, image, option = {})
    draw_morph(x1, y1, x2, y1, x2, y2, x1, y2, image, option)
  end
end