require_relative 'define'
require_relative 'Map'
WALKTIME = 15

class Chara < Sprite
  attr_accessor :walk_vec, :anim_count, :walk_flag, :target_x, :target_y, :speed, :images

  def initialize(_x, _y, add)
    @images = Image.load_tiles(add, 3, 4)
    super(_x, _y, images[1])
    self.x = self.target_x = _x * CELL_WIDTH
    self.y = self.target_y = _y * CELL_HEIGHT
    @walk_vec = 2
    @walk_flag = false
    @anim_count = 0
    @target_x = x
    @target_y = y
    @speed = 1
    self.scale_y = (CELL_HEIGHT + 1 * (height - width)) / height.to_f
  end

  def animation_view(anim_state, first_num)
    case anim_state
    when 0
      self.image = images[first_num]
    when 1, 3
          self.image = images[first_num + 1]
    when 2
      self.image = images[first_num + 2]
    end
    draw
  end

  def move(map, walk_switch)
    self.walk_flag = false
    if target_x == x && target_y == y
      case walk_switch
      when 2
        self.walk_vec = walk_switch
        self.walk_flag = true
        if map.all?{|_m| _m.cell[:can_walk][y / CELL_HEIGHT + 1][x / CELL_WIDTH] }
          map[0].cell[:can_walk][y / CELL_HEIGHT + 1][x / CELL_WIDTH] = false
          map[0].cell[:can_walk][y / CELL_HEIGHT][x / CELL_WIDTH] = true
          self.target_y += CELL_HEIGHT
        end
      when 4
        self.walk_vec = walk_switch
        self.walk_flag = true
        if map.all?{|_m| _m.cell[:can_walk][y / CELL_HEIGHT][x / CELL_WIDTH - 1] }
          map[0].cell[:can_walk][y / CELL_HEIGHT][x / CELL_WIDTH - 1] = false
          map[0].cell[:can_walk][y / CELL_HEIGHT][x / CELL_WIDTH] = true
          self.target_x -= CELL_WIDTH
        end
      when 6
        self.walk_vec = walk_switch
        self.walk_flag = true
        if map.all?{|_m| _m.cell[:can_walk][y / CELL_HEIGHT][x / CELL_WIDTH + 1] }
          map[0].cell[:can_walk][y / CELL_HEIGHT][x / CELL_WIDTH + 1] = false
          map[0].cell[:can_walk][y / CELL_HEIGHT][x / CELL_WIDTH] = true
          self.target_x += CELL_WIDTH
        end
      when 8
        self.walk_vec = walk_switch
        self.walk_flag = true
        if map.all?{|_m| _m.cell[:can_walk][y / CELL_HEIGHT - 1][x / CELL_WIDTH] }
          map[0].cell[:can_walk][y / CELL_HEIGHT - 1][x / CELL_WIDTH] = false
          map[0].cell[:can_walk][y / CELL_HEIGHT][x / CELL_WIDTH] = true
          self.target_y -= CELL_HEIGHT
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

    case walk_vec
    when 2
      if walk_flag
        animation_view(anim_state, 0)
        self.anim_count += 1
      else
        self.image = images[1]
        draw
      end
    when 4
      if walk_flag
        animation_view(anim_state, 3)
        self.anim_count += 1
      else
        self.image = images[4]
        draw
      end
    when 6
      if walk_flag
        animation_view(anim_state, 6)
        self.anim_count += 1
      else
        self.image = images[7]
        draw
      end
    when 8
      if walk_flag
        animation_view(anim_state, 9)
        self.anim_count += 1
      else
        self.image = images[10]
        draw
      end
    end

  end

  def update
    view
  end

  def draw
    self.y -= 1 * (height - width)
    super
    self.y += 1 * (height - width)
  end

end

class Player < Chara
  attr_accessor :status

  Status = Struct.new(:name, :level, :hp, :hp_max, :mp, :mp_max, :attack, :strength, :defense, :toughness, :agility)

  def initialize(add, _x = 1, _y = 1)
    super(_x, _y, add)
    self.walk_vec = 2
    self.speed = 2

  end

  def action(e_map)
    if Input.key_push?(K_SPACE)
      e_map.ev.each do |ev|
        _x = ev.x * CELL_WIDTH
        _y = ev.y * CELL_HEIGHT
        case walk_vec
        when 2
          if _x == x && _y == y + CELL_HEIGHT
            ev.activate(walk_vec)
            break
          end
        when 4
          if _x == x - CELL_WIDTH && _y == y
            ev.activate(walk_vec)
            break
          end
        when 6
          if _x == x + CELL_WIDTH && _y == y
            ev.activate(walk_vec)
            break
          end
        when 8
          if _x == x && _y == y - CELL_HEIGHT
            ev.activate(walk_vec)
            break
          end
        end
      end
    end
  end

  def update(map, e_map)
    walk_switch = 0
    walk_switch = 2 if Input.y > 0
    walk_switch = 4 if Input.x < 0
    walk_switch = 6 if Input.x > 0
    walk_switch = 8 if Input.y < 0

    action(e_map)
    move(map, walk_switch)
    view


  end
end

class Villager < Chara
  attr_accessor :msg, :walk_count

  def initialize(_x, _y, add1, add2)
    super(_x, _y, add1)
    @msg = MessageWindow.new(add2)
    @walk_count = 0
  end

  def reset(player_vec)
    msg.reset unless msg.live
    case player_vec
    when 2
      self.walk_vec = 8
    when 4
      self.walk_vec = 6
    when 6
      self.walk_vec = 4
    when 8
      self.walk_vec = 2
    end
  end

  def update(map)
    self.walk_count += 1
    walk_switch = 0
    if walk_count % 120 == 0
      self.walk_count = 0
      walk_switch = rand(1..4) * 2
    end
    if msg.live
      msg.update
    else
      move(map, walk_switch)
    end
    view
  end
end

class Party
  attr_accessor :party, :e_map, :map

  def initialize(_e_map, _map)
    @e_map = _e_map
    @map = _map
    @party = []
    insert(0, Player.new('Image/Player.png'))
    insert(1, Player.new('Image/PartyMember1.png'))
    insert(2, Player.new('Image/PartyMember2.png'))
    insert(3, Player.new('Image/PartyMember3.png'))
    insert(4, Player.new('Image/PartyMember4.png'))
  end

  def insert(num, addition)
    return if num > party.size
    party[num] = addition
    if num > 0
      (num...party.size).each do |i|
        party[i].x = party[i].target_x = party[i - 1].x
        party[i].y = party[i].target_y = party[i - 1].y
      end
    end
  end

  def erace(num)
    return if num >= party.size

    map[0].cell[:can_walk][party[num].y / CELL_HEIGHT][party[num].x / CELL_WIDTH] = true
    party.delete_at(num)

    (num...party.size).each do |i|
      walk_switch = 0
      if (party[i].y - party[i - 1].y).abs < CELL_HEIGHT
        walk_switch = 6 if party[i].x < party[i - 1].x
        walk_switch = 4 if party[i].x > party[i - 1].x
      elsif (party[i].x - party[i - 1].x).abs < CELL_WIDTH
        walk_switch = 2 if party[i].y < party[i - 1].y
        walk_switch = 8 if party[i].y > party[i - 1].y
      end
      party[i].walk_flag = party[0].walk_flag
      party[i].move(map, walk_switch) if (party[i].target_x != party[i - 1].target_x) || (party[i].target_y != party[i - 1].target_y)
    end

    party.each do |p|
      map[0].cell[:can_walk][p.y / CELL_HEIGHT][p.x / CELL_WIDTH] = false
    end
  end

  def move
    party.each do |p|
      map[0].cell[:can_walk][p.y / CELL_HEIGHT][p.x / CELL_WIDTH] = true
    end

    walk_switch = 0
    walk_switch = 2 if Input.y > 0
    walk_switch = 4 if Input.x < 0
    walk_switch = 6 if Input.x > 0
    walk_switch = 8 if Input.y < 0
    party[0].move(map, walk_switch)
    party[0].action(e_map)

    (1...party.size).each do |i|
      walk_switch = 0
      if Input.x.abs + Input.y.abs != 0
        if (party[0].x != party[0].target_x) || (party[0].y != party[0].target_y)
          if (party[i].y - party[i - 1].y).abs < CELL_HEIGHT
            walk_switch = 6 if party[i].x < party[i - 1].x
            walk_switch = 4 if party[i].x > party[i - 1].x
          elsif (party[i].x - party[i - 1].x).abs < CELL_WIDTH
            walk_switch = 2 if party[i].y < party[i - 1].y
            walk_switch = 8 if party[i].y > party[i - 1].y
        end
      end
      end
      party[i].walk_flag = party[0].walk_flag
      party[i].move(map, walk_switch) if (party[i].target_x != party[i - 1].target_x) || (party[i].target_y != party[i - 1].target_y)
    end

    party.each do |p|
      map[0].cell[:can_walk][p.y / CELL_HEIGHT][p.x / CELL_WIDTH] = false
    end
  end

  def view
    Window.ox = if party[0].x <= Window.width / 2
                  0
                elsif party[0].x >= map[0].width - Window.width / 2
                  map[0].width - Window.width
                else
                  party[0].x - Window.width / 2
                end
    Window.oy = if party[0].y <= Window.height / 2
                  0
                elsif party[0].y >= map[0].height - Window.height / 2
                  map[0].height - Window.height
                else
                  party[0].y - Window.height / 2
                end

    party.reverse_each do |p|
      p.view
    end
  end
  end