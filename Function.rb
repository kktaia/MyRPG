require 'dxruby'
require_relative 'define.rb'

module Camera
    @view_x=0
    @view_y=0

    class << self
        def draw (x1,y1,x2,y2,gh,change_vx=0,change_vy=0,option={})
            @view_x=change_vx if change_vx!=0
            @view_y=change_vy if change_vy!=0

            x1-=@view_x;x2-=@view_x-1
            y1-=@view_y;y2-=@view_y-1

            Window.draw_morph(x1,y1,x2,y1,x2,y2,x1,y2,gh,option)
        end
        def x
            @view_x
        end
        def y
            @view_y
        end
    end
end