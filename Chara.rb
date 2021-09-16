require 'dxruby'
WALKTIME=15    

class Player
    attr_accessor :gh,:x,:y,:width,:height
    attr_accessor :walk_vec,:anim_count,:walk_flag

    def initialize
        @x=0
        @y=0
        @gh=Image.load_tiles("Image/Player.png",3,4)
        @width=gh[0].width
        @height=gh[0].height
    end

    def view
        gh.each_with_index do |g,i|
            Window.draw(i*25,y,g)
        end
    end

    def all
        view
    end
end