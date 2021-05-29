class Equipamento < ApplicationRecord
  enum tipo: {
    ONU: 1,
    Radio: 2,
    OLT: 3,
    Radio_PtP: 4,
    Roteador: 5,
    Switch: 6
  }

end
