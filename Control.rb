require 'dxruby'
require_relative 'define.rb'
require_relative 'Map.rb'
require_relative 'Chara.rb'
require_relative 'WindowBox.rb'

class Control
    attr_accessor :pl,:map,:ev,:msg
    attr_accessor :cam_x,:cam_y

    def initialize
        @cam_x=@cam_y=0
        @pl=Player.new("Image/Player.png")
        @map=[]
        map[0]=Map.new("csv/flame1.csv")
        map[1]=Map.new("csv/flame2.csv")
        map[2]=Map.new("csv/flame3.csv")
        @ev=EventMap.new("csv/event.csv")
        pl.x=pl.target_x=CELL_WIDTH
        pl.y=pl.target_y=CELL_HEIGHT
        @msg=Waku.new(0,360,WINDOW_X,120)
    end
    def all
        
        map.each(&:back_view)
        ev.all
        pl.all(map,ev)
        map.each(&:front_view)
        msg.view
    end
end