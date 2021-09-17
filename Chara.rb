require_relative 'define'
require_relative 'Map'
WALKTIME = 15

class Player < Sprite
  attr_accessor :walk_vec, :anim_count, :walk_flag, :target_x, :target_y, :speed

  IMAGES = Image.load_tiles('Image/Player.png', 3, 4)

  def initialize
    super
    @walk_vec = 2
    @walk_flag = false
    @anim_count = 0
    @target_x = x
    @target_y = y
    @speed = 1
  end

  def animation_view(anim_state, first_num)
    case anim_state
    when 0
      self.image = IMAGES[first_num]
    when 1, 3
          self.image = IMAGES[first_num + 1]
    when 2
      self.image = IMAGES[first_num + 2]
    end
    draw
  end

  def move(map)
    self.walk_flag = false
    if target_x == x && target_y == y
      if Input.x + Input.y != 0
        self.walk_flag = true
        self.walk_vec = if Input.y > 0
                          self.target_y += CELL_HEIGHT if map.cell[:can_walk][x/CELL_WIDTH][y/CELL_HEIGHT + 1]
                          2
                        elsif Input.x < 0
                          self.target_x -= CELL_WIDTH if map.cell[:can_walk][x/CELL_WIDTH - 1][y/CELL_HEIGHT]
                          4
                        elsif Input.x > 0
                          self.target_x += CELL_WIDTH if map.cell[:can_walk][x/CELL_WIDTH + 1][y/CELL_HEIGHT]
                          6
                        elsif Input.y < 0
                          self.target_y -= CELL_HEIGHT if map.cell[:can_walk][x/CELL_WIDTH][y/CELL_HEIGHT - 1]
                          8
                        end
      else
        self.anim_count = 0
      end
    else
      self.walk_flag = true
    end
    self.y += speed if y < target_y
    self.x -= speed if x > target_x
    self.x += speed if x < target_x
    self.y -= speed if y > target_y
  end

  def view
    anim_state = anim_count/WALKTIME
    self.anim_count = anim_state = 0 if anim_state == 4
    if walk_flag
      case walk_vec
      when 2
        animation_view(anim_state, 0)
      when 4
        animation_view(anim_state, 3)
      when 6
        animation_view(anim_state, 6)
      when 8
        animation_view(anim_state, 9)
      end
      self.anim_count += 1
    else
      case walk_vec
      when 2
        self.image = IMAGES[1]
      when 4
        self.image = IMAGES[4]
      when 6
        self.image = IMAGES[7]
      when 8
        self.image = IMAGES[10]
      end
      draw
    end
  end

  def update(map)
    move(map)
    view
  end

  def draw
    self.y -= 2 * (height - width)
    super
    self.y += 2 * (height - width)
  end

end