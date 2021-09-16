require 'dxruby'
require_relative 'WindowBox.rb'

class Event
    attr_accessor :x,:y,:msg

    def initialize (hash)
        @x=hash[:X座標].to_i
        @y=hash[:Y座標].to_i
        @msg=nil
        case hash[:イベントタイプ]
        when "メッセージ" then
            @msg=MessageWindow.new(hash[:アドレス])
        end
    end
    def activate
        msg.reset if msg!=nil
    end
    def all
        msg.all if msg!=nil
    end
end