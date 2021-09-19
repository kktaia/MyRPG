require 'dxruby'
require 'csv'
require_relative 'define'

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
                self.cell[:gh][num[2].to_i][y][x] = num[0].to_i
                self.cell[:can_walk][y][x] = num[1].to_i == 1
            end
        end
        @width = cell[:can_walk][0].size * CELL_WIDTH
        @height = cell[:can_walk].size * CELL_HEIGHT
    end

    def view
        Window.draw_tile(0, 0, cell[:gh][0], TOWN_CHIP, 0, 0, CELL_NUM_X, CELL_HEIGHT, -1)
        Window.draw_tile(0, 0, cell[:gh][1], TOWN_CHIP, 0, 0, CELL_NUM_X, CELL_HEIGHT, 1)
    end

    def update
        view
    end
end