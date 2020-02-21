require "parseline"

class Retorno240Header
  attr_accessor :sequencia
  attr_accessor :data
  attr_accessor :convenio
  attr_accessor :banco

  extend ParseLine::FixedWidth

  fixed_width_layout do |parse|
    parse.field :banco, 0..2
    parse.field :convenio, 52..62
    parse.field :data, 143..150
    parse.field :sequencia, 157..162
  end
end
