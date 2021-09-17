require 'dxruby'
require 'csv'
require_relative 'define'

class Map
    TOWN_CHIP = Image.load_tiles('Image/town_map.png', 128/16, 128/16)
    attr_accessor :cell, :can_walk

    def initialize
        @cell = Array.new(CELL_NUM_Y) {Array.new(CELL_NUM_X)}
        CSV.read('csv/testmap.csv') do |row|
            row.each do |c|
                self.cell
            end
        end
    end

    def view
        Window.draw_tile(0, 0, cell, TOWN_CHIP, 0, 0, CELL_NUM_X, CELL_HEIGHT, -1)
    end

    def update
        view
    end
end