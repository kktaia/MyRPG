require 'dxruby'
require 'csv'
require_relative 'define.rb'
require_relative 'Function.rb'
require_relative 'WindowBox.rb'
require_relative 'Event.rb'


Cell=Struct.new(:canwalk)

class Map
    attr_accessor :chipgh,:map,:map_cell
    attr_accessor :width,:height
    
    def initialize (add)
        @chipgh=Image.load_tiles("Image/BaseChip.png",128/16,3984/16)
        @map_cell=Array.new(CELL_NUM_X){Array.new(CELL_NUM_Y)}
        @width=0
        @height=0
        @map=[Array.new(CELL_NUM_Y){Array.new(CELL_NUM_X)},Array.new(CELL_NUM_Y){Array.new(CELL_NUM_X)}]
        CSV.read(add).each_with_index do |array,j|
            array.each_with_index do |index,i|
                num=index.split(/;/)[0].to_i
                can=(index.split(/;/)[1].to_i==1)
                draw=index.split(/;/)[2].to_i
                self.map_cell[i][j]=Cell.new(can)
                @map[draw][j][i]=num
            end
            self.width=array.length*CELL_WIDTH if @width<array.length*CELL_WIDTH 
            
        end
        self.height=CSV.read(add).length*CELL_HEIGHT
    end
    def front_view
        Window.draw_tile(-1,-1,map[1],chipgh,0,0,CELL_WIDTH,CELL_HEIGHT,1)
    end
    def back_view
        Window.draw_tile(nil,nil,map[0],chipgh,nil,nil,CELL_WIDTH,CELL_HEIGHT,-1)
    end
    def all
        #view
    end
end

class EventMap
    attr_accessor :ev
    def initialize (add)
        @ev=[]
        CSV.foreach(add,headers:true) do |row|
            ev.push(Event.new(row.to_h.transform_keys(&:to_sym)))
        end
    end
    def all
        ev.each do |e|
            e.all
        end
    end
end