module RetornosHelper
  def cnab_to_float(s)
    s.to_f / 100
  end

  def cnab_to_currency(s)
    number_to_currency(s.to_f / 100)
  end

  def cnab_to_date(s)
    Date.strptime(s, "%d%m%y")
  end
end
