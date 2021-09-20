require 'dxruby'
require_relative 'WindowBox'
require_relative 'Chara'

class Event
    attr_accessor :x, :y, :event

    def initialize(hash)
        @x = hash[:X]
        @y = hash[:Y]
        case hash[:EventType]
        when "メッセージ"
            @event = MessageWindow.new(hash[:Address1])
        when "村人"
            @event = Villager.new(hash[:X], hash[:Y], hash[:Address1], hash[:Address2])
        end
    end
    def activate(walk_vec)
        case event
        when MessageWindow
            event.reset
        when Villager
            event.reset(walk_vec)
        end
    end
    def update(map)
        case event
        when MessageWindow
            event.update
        when Villager
            event.update(map)
            self.x = event.target_x / CELL_WIDTH
            self.y = event.target_y / CELL_WIDTH
        end
    end
end