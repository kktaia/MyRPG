require 'dxruby'
require 'csv'
require_relative 'define'
require_relative 'Event'

class Map
  TOWN_CHIP = Image.load_tiles('Image/town_map.png', 128/16, 128/16)
  attr_accessor :cell, :width, :height

  def initialize(add)
    @cell = {
      gh: [Array.new(CELL_NUM_Y) {Array.new(CELL_NUM_X)},
           Array.new(CELL_NUM_Y) {Array.new(CELL_NUM_X)}],
      can_walk: Array.new(CELL_NUM_Y) {Array.new(CELL_NUM_X)}
    }
    CSV.read(add).each_with_index do |row, y|
      row.each_with_index do |box, x|
        num = box.split(';')
        cell[:gh][num[2].to_i][y][x] = num[0].to_i
        cell[:can_walk][y][x] = num[1].to_i == 1
      end
    end
    @width = cell[:can_walk][0].size * CELL_WIDTH
    @height = cell[:can_walk].size * CELL_HEIGHT
  end

  def view
    Window.draw_tile(0, 0, cell[:gh][0], TOWN_CHIP, 0, 0, CELL_NUM_X, CELL_NUM_Y, -1)
    Window.draw_tile(0, 0, cell[:gh][1], TOWN_CHIP, 0, 0, CELL_NUM_X, CELL_NUM_Y, 1)
  end

  def update
    view
  end
end

class EventMap
  attr_accessor :ev

  def initialize(add)
    @ev = []
    CSV.read(add, headers: :first_row, converters: :integer).each do |row|
      ev << Event.new(row.to_h.transform_keys(&:to_sym))
    end
  end

  def update(map)
    ev.each do |ev|
      ev.update(map)
    end
  end
end

class WorldMap
  attr_accessor :cell, :ev

  WORLD_CHIP = Image.load_tiles('Image/world_map.png', 8, 8)
  CELL_DESC = {
    SEA: [{ b: 192, g: 160, r: 0 }, 0],
    SEA2: [{ b: 192, g: 64, r: 64 }, 0],
    SEA3: [{ b: 192, g: 64, r: 160 }, 0],
    PLANE: [{ b: 0, g: 224, r: 192 }, 1],
    DESERT: [{ b: 176, g: 228, r: 239 }, 1],
    TOWN: [{ b: 64, g: 192, r: 32 }, 1],
    DUNGEON: [{ b: 64, g: 32, r: 224 }, 1]
  }.freeze

  def initialize(add)
    @cell = {
      gh: Array.new(CELL_NUM_Y) {Array.new(CELL_NUM_X)},
      can_walk: Array.new(CELL_NUM_Y) {Array.new(CELL_NUM_X)}
    }
    x = CELL_NUM_WX - 1
    y = CELL_NUM_WY - 1
    54.step(File.size(add) - 3, 3) do |offset|
      bgr = {}
      bgr[:b] = File.binread(add, 1, offset).unpack1('C*')
      bgr[:g] = File.binread(add, 1, offset + 1).unpack1('C*')
      bgr[:r] = File.binread(add, 1, offset + 2).unpack1('C*')
      CELL_DESC.each_with_index do |key, value, index|
        next unless value[0] === bgr

        cell[:gh][y][x] = index
        cell[:can_walk] = value[1]
        break
      end
      x -= 1
      if x.negative?
        y -= 1
        x = CELL_NUM_WX - 1
      end
    end
    @ev = []
    CSV.read('csv/world_map_ev.csv', headers: :first_row, converters: :integer).each do |row|
      ev << Event.new(row.to_h.transform_keys(&:to_sym))
    end
  end

  def view
    Window.draw_tile(0, 0, cell[:gh], WORLD_CHIP, 0, 0, CELL_NUM_WX, CELL_NUM_WY, -1)
  end

  def update
    view
  end
end

class ChangeMap
  DATA = CSV.read('csv/change_map.csv', headers: :first_row, converters: :integer)
end