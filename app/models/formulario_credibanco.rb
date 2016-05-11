class FormularioCredibanco
  
  def self.generar(params)
    pdf = Prawn::Document.new(left_margin: 50,
                        top_margin:50,
                        page_size: [678, 1074.24])
    pdf.move_down 30
    pdf.draw_text 'X', size: 10, at: [19, pdf.cursor]
    pdf.draw_text 'X', size: 10, at: [97, pdf.cursor]

    pdf.move_down 87
    pdf.draw_text 'X', size: 10, at: [96, pdf.cursor]
    
    pdf.move_down 27
    pdf.draw_text params[:razon_social], size: 10, at: [4, pdf.cursor]
    
    pdf.move_down 26
    case params[:tipo_documento_comercio]
    when "NIT"
      pdf.draw_text 'X', size: 10, at: [20, pdf.cursor]
    when "C.C."
      pdf.draw_text 'X', size: 10, at: [55, pdf.cursor]
    when "C.E."
      pdf.draw_text 'X', size: 10, at: [87, pdf.cursor]
    end
    pdf.text_box params[:numero_documento_comercio], size: 10, width: 70,
        at: [125, pdf.cursor+8], character_spacing: 4
    unless params[:numero_de_matricula_mercantil].blank?
      pdf.draw_text 'X', size: 10, at: [325, pdf.cursor]
      pdf.text_box params[:numero_de_matricula_mercantil], size: 10, width: 60,
            at: [356, pdf.cursor+8], character_spacing: 4
    end

    pdf.move_down 26
    pos_y = pdf.cursor
    case params[:tipo_de_empresa]
    when "Anónima"
      pdf.draw_text 'X', size: 10, at: [34, pos_y]
    when "S.A.S."
      pdf.draw_text 'X', size: 10, at: [119, pos_y]
    when "Pública"
      pdf.draw_text 'X', size: 10, at: [168, pos_y]
    when "Mixta"
      pdf.draw_text 'X', size: 10, at: [211, pos_y]
    when "Limitada"
      pdf.draw_text 'X', size: 10, at: [34, pos_y-16]
    when "Sin ánimo de lucro"
      pdf.draw_text 'X', size: 10, at: [119, pos_y-16]
    when "Privada"
      pdf.draw_text 'X', size: 10, at: [168, pos_y-16]
    else
      pdf.draw_text params[:tipo_de_empresa], size: 10, at: [1, pos_y]
    end

    case params[:naturaleza]
    when "Jurídica"
      pdf.draw_text 'X', size: 10, at: [475, pos_y]
    when "Natural"
      pdf.draw_text 'X', size: 10, at: [475, pos_y-16]
    end
    
    pdf.move_down 32
    pos_y = pdf.cursor
    case params[:agencia_de_viajes]
    when "Agencia de viajes"
      pdf.draw_text 'X', size: 10, at: [65, pos_y]
    when "Venta propia"
      pdf.draw_text 'X', size: 10, at: [127, pos_y]
    when "Venta propia y de tiquetes"
      pdf.draw_text 'X', size: 10, at: [231, pos_y]
    when "Aerolínea"
      pdf.draw_text 'X', size: 10, at: [400, pos_y]
    end
    unless params[:numero_iata_av].blank?
      pdf.text_box params[:numero_iata_av], size: 10, width: 50,
            at: [276, pos_y+8], character_spacing: 4
    end

    case params[:requiere_impuestos_av]
    when "Sí"
      pdf.draw_text 'X', size: 10, at: [499, pos_y]
    when "No"
      pdf.draw_text 'X', size: 10, at: [527, pos_y]
    end

    # Sección actividad comercial y responsabilidad tributaria
    pdf.move_down 13
    pos_y = pdf.cursor
    pdf.draw_text params[:actividad_comercial], size: 10, at: [71, pos_y]
    cadena = preprocesar(params[:responsabilidad_tributaria])
    pdf.text_box cadena, size: 10, width: 210,
            at: [7, pos_y+8-40], character_spacing: 4.5
    pdf.text_box params[:codigo_ciiu], size: 9, width: 30,
            at: [416, pos_y+8-27], character_spacing: 4.8
    pdf.text_box params[:mcc], size: 9, width: 30,
            at: [416, pos_y+8-39], character_spacing: 4.8
            
    # Sección Tipo de afiliación
    pdf.move_down 70
    pos_y = pdf.cursor
    pdf.draw_text 'X', size: 10, at: [86, pos_y] if params[:venta_presencial_ta] == "1"
    pdf.draw_text 'X', size: 10, at: [149, pos_y] if params[:mi_pago_ta] == "1"
    pdf.draw_text 'X', size: 10, at: [60, pos_y-25] if params[:multicomercio_ta] == "1"
    case params[:comercio_principal_secundario_ta]
    when "Principal"
      pdf.draw_text 'X', size: 10, at: [149, pos_y-25]
    when "Secundario"
      pdf.draw_text 'X', size: 10, at: [245, pos_y-25]
    end
    
    # Sección Venta No Presencial
    pdf.move_down 40
    pos_y = pdf.cursor
    pdf.draw_text 'X', size: 10, at: [78, pos_y] if params[:venta_no_presencial] == "1"
    pdf.draw_text 'X', size: 10, at: [78, pos_y-12] if params[:paga_cuentas] == "1"
    pdf.draw_text 'X', size: 10, at: [234, pos_y-12] if params[:visa_distribucion] == "1"
    pdf.draw_text 'X', size: 10, at: [294, pos_y-12] if params[:pse] == "1"
    pdf.draw_text 'X', size: 10, at: [78, pos_y-24] if params[:web_de_pagos] == "1"
    pdf.draw_text 'X', size: 10, at: [150, pos_y-24] if params[:recurrente] == "1"
    pdf.draw_text 'X', size: 10, at: [180, pos_y-24] if params[:api] == "1"
    pdf.draw_text 'X', size: 10, at: [256, pos_y-24] if params[:boton_de_pagos] == "1"
    pdf.draw_text 'X', size: 10, at: [324, pos_y-24] if params[:mall_virtual] == "1"

    pdf
  end
  
  private
  
  def self.preprocesar(codigos_responsabilidad_tributaria)
    # Primero eliminar los separadores que pueden ser: espacio, guión o coma.
    arreglo = codigos_responsabilidad_tributaria.split((%r{,|-|\s+}))
    # Se retorna un string concatenando las subcadenas del arreglo
    arreglo.join
  end
end