require 'dxruby'
require_relative 'Function.rb'


class Waku
    attr_accessor :x,:y,:width,:height
    attr_accessor :gh,:live
    def initialize (set_x,set_y,set_width,set_height)
        @x=set_x
        @y=set_y
        @width=set_width
        @height=set_height
        @gh=Image.load_tiles("Image/WindowBase.png",3,3)
        @live=false
    end
    def view
        Window.draw_morph(x,y,x+6,y,x+6,y+6,x,y+6,gh[0])
        Window.draw_morph(x+6,y,x+width-6,y,x+width-6,y+6,x+6,y+6,gh[1])
        Window.draw_morph(x+width-6,y,x+width,y,x+width,y+6,x+width-6,y+6,gh[2])
        Window.draw_morph(x,y+6,x+6,y+6,x+6,y+height-6,x,y+height-6,gh[3])
        Window.draw_morph(x+6,y+6,x+width-6,y+6,x+width-6,y+height-6,x+6,y+height-6,gh[4])
        Window.draw_morph(x+width-6,y+6,x+width,y+6,x+width,y+height-6,x+width-6,y+height-6,gh[5])
        Window.draw_morph(x,y+height-6,x+6,y+height-6,x+6,y+height,x,y+height,gh[6])
        Window.draw_morph(x+6,y+height-6,x+width-6,y+height-6,x+width-6,y+height,x+6,y+height,gh[7])
        Window.draw_morph(x+width-6,y+height-6,x+width,y+height-6,x+width,y+height,x+width-6,y+height,gh[8])
    end
end

class MessageWindow < Waku
    attr_accessor :txt,:page,:gyou
    def initialize (add)
        super(0,360,640,120)
        @txt=[]
        @page=@gyou=0
        File.open(add,"r") do |f|
            self.txt=f.read.split(/;\n/).map do |x|
                x.split(/\n/)
            end
        end
    end
    def reset
        self.live=true
        self.page=self.gyou=0
    end
    def read
        if Input.key_push?(K_SPACE)
            if txt[page][gyou+1]!=nil
                self.gyou+=1
            else
                self.page+=1
                self.gyou=0
            end
            if txt[page]==nil  
                self.live=false
                return
            end 
        end
        for i in 0..gyou do
            Window.draw_font(x+10, y+10+20*i,txt[page][i],FONT,{color:C_WHITE})
        end
    end
    def all
        if live
            view
            read
        end
    end
end