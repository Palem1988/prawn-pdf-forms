class NumeroString
  include  ActionView::Helpers::NumberHelper

  def initialize(val)
    @valor = val
  end
  
  def to_s
    number_with_delimiter(@valor, delimiter: ".")
  end
end