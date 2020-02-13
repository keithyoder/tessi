class RadAcct < ApplicationRecord
  self.table_name = "radacct"
  self.primary_key = "radacctid"
  belongs_to :conexao, :primary_key => :username, :foreign_key => :usuario
  scope :trafego, -> {
          select("date(acctstoptime) as dia, sum(acctoutputoctets) as upload, sum(acctinputoctets) as download")
            .group("date(acctstoptime)")
        }
end
