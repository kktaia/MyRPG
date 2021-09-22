require 'dxruby'
require_relative 'Function.rb'


class Waku
    attr_accessor :x, :y, :width, :height, :live

    IMAGES = Image.load_tiles('Image/WindowBase.png', 3, 3)

    def initialize (_x, _y, _width, _height)
        @x = _x
        @y = _y
        @width = _width
        @height = _height
        @live = false
    end

    def x
        @x + Window.ox
    end

    def y
        @y + Window.oy
    end

    def view
        #_x = self.x + Window.ox
        #_y = self.y + Window.oy
        Window.draw_extend(x, y, x + 6, y + 6, IMAGES[0])
        Window.draw_extend(x + 6, y, x + width - 6, y + 6, IMAGES[1])
        Window.draw_extend(x + width - 6, y, x + width, y + 6, IMAGES[2])
        Window.draw_extend(x, y + 6, x + 6, y + height - 6, IMAGES[3])
        Window.draw_extend(x + 6, y + 6, x + width - 6, y + height - 6, IMAGES[4])
        Window.draw_extend(x + width - 6, y + 6, x + width, y + height - 6, IMAGES[5])
        Window.draw_extend(x, y + height - 6, x + 6, y + height, IMAGES[6])
        Window.draw_extend(x + 6, y + height - 6, x + width - 6, y + height, IMAGES[7])
        Window.draw_extend(x + width - 6, y + height - 6, x + width, y + height, IMAGES[8])
    end
end

class MessageWindow < Waku
    attr_accessor :txt, :page, :line, :reset_flag

    FONT = Font.new(20)

    def initialize(add)
        super(0, 360, Window.width, 120)
        @txt = []
        @page = @line = 0
        @reset_flag = false
        File.open(add) do |f|
            f2 = f.read.split(";\n")
            f2.each do |p|
                txt << p.split("\n")
            end
        end
    end

    def reset
        self.live = true
        self.page = self.line = 0
        $state = :MESSAGE
        self.reset_flag = true
    end

    def read
        txt[page].each_with_index do |l, i|
            Window.draw_font(x + 10, y + 10 + FONT.size * i, l, FONT, color:C_WHITE)
            break if line == i
        end
        if reset_flag
            self.reset_flag = false
            return
        end
        if Input.key_push?(K_SPACE)
            if txt[page][line + 1] && line < txt[page].size
                self.line += 1
            else
                self.line = 0
                self.page += 1
            end
            if !txt[page]
                self.live = false
                $state = :NONE
            end
        end
    end

    def update
        if live
            view
            read
        end
    end
end