module ApplicationHelper

  def titulo_completo(titulo_pagina = '')
    titulo_base = "Formularios"
    if titulo_pagina.empty?
      titulo_base
    else
      "#{titulo_pagina} | #{titulo_base}"
    end
  end
end
