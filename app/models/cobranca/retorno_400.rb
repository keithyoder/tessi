require "parseline"

class Retorno400Header
  attr_accessor :retorno
  attr_accessor :tipo
  attr_accessor :sequencia
  attr_accessor :data
  attr_accessor :convenio
  attr_accessor :banco

  extend ParseLine::FixedWidth

  fixed_width_layout do |parse|
    parse.field :retorno, 1..1
    parse.field :tipo, 9..10
    parse.field :banco, 76..79
    parse.field :convenio, 149..155
    parse.field :data, 94..99
    parse.field :sequencia, 100..106
  end
end
