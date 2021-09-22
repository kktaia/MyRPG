require 'dxruby'
require_relative 'define'
require_relative 'Map'
require_relative 'Chara'
require_relative 'WindowBox'

class Control
  attr_accessor :p_party, :map, :e_map, :w_map, :mode

  def initialize
    @w_map = WorldMap.new('world_map.bmp')
    @map = [
      Map.new('csv/flame1.csv'),
      Map.new('csv/flame2.csv'),
      Map.new('csv/flame3.csv')
    ]
    @e_map = EventMap.new('csv/event.csv')
    @p_party = Party.new(e_map, map)
    @mode = :game
  end

  def view
    case $location
    when :WORLD
      w_map.view
      p_party.view
    when :TOWN
      Sprite.update(map)
      p_party.view
      e_map.update(map)
    end
  end

  def game
    case $state
    when :NONE
      view
      p_party.move
      p_party.erace(1) if Input.key_push?(K_Q)
    when :MESSAGE
      view
    end
    e_map.update(map)
    Sprite.update(map)
  end

  def update
    send(mode)
  end
end