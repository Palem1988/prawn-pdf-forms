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
    pdf.draw_text 'X', size: 10, at: [527, pos_y-12] if params[:modulo_basico_afs] == "1"
    pdf.draw_text 'X', size: 10, at: [527, pos_y-24] if params[:modulo_avanzado_cybersource] == "1"
    
    # Sección Dirección del establecimiento
    pdf.move_down 65
    pos_y = pdf.cursor
    pdf.text_box params[:direccion_del_establecimiento], size: 7, at: [1, pos_y+13],
        width: 160
    pdf.draw_text params[:telefono_del_establecimiento], size: 10, at: [175, pos_y]
    pdf.draw_text params[:celular], size: 10, at: [285, pos_y]
    pdf.draw_text params[:fax], size: 10, at: [395, pos_y]
    pdf.text_box params[:codigo_ciudad], size: 9, width: 30,
            at: [509, pos_y+21], character_spacing: 4.8
    pdf.text_box params[:codigo_departamento], size: 9, width: 30,
            at: [509, pos_y+9], character_spacing: 4.8

    # Sección Dirección de correspondencia/notificaciones
    pdf.move_down 25
    pos_y = pdf.cursor
    pdf.text_box params[:direccion_correspondencia], size: 7, at: [1, pos_y+13],
        width: 160
    pdf.draw_text params[:telefono_correspondencia], size: 10, at: [175, pos_y]
    pdf.text_box params[:ciudad_correspondencia], size: 7, at: [285, pos_y+13],
        width: 110
    case params[:horario_atencion]
    when "Diurno"
      pdf.draw_text 'X', size: 10, at: [421, pos_y+1]
    when "Nocturno"
      pdf.draw_text 'X', size: 10, at: [473, pos_y+1]
    when "24 horas"
      pdf.draw_text 'X', size: 10, at: [523, pos_y+1]
    end

    # Sección presencia en Internet
    pdf.text_box params[:correo_electronico], size: 7, at: [1, pos_y-16],
        width: 160
    pdf.text_box params[:direccion_pagina_web], size: 7, at: [175, pos_y-16],
        width: 160
    pdf.draw_text 'X', size: 9, at: [463, pos_y-13] if params[:facebook] == "1"
    pdf.draw_text 'X', size: 9, at: [510, pos_y-13] if params[:twitter] == "1"
    pdf.draw_text 'X', size: 9, at: [557.5, pos_y-13] if params[:youtube] == "1"
    pdf.draw_text 'X', size: 9, at: [351, pos_y-27] if params[:foursquare] == "1"
    pdf.draw_text 'X', size: 9, at: [391, pos_y-27] if params[:flickr] == "1"
    pdf.draw_text 'Linkedin', size: 9, at: [454, pos_y-24] if params[:linkedin] == "1"

    # Sección tipo de establecimiento
    pdf.move_down 60
    pos_y = pdf.cursor
    case params[:tipo_de_establecimiento]
    when "Principal"
      pdf.draw_text 'X', size: 9, at: [127, pos_y]
    when "Sucursal"
      pdf.draw_text 'X', size: 9, at: [178, pos_y]
    end
    pdf.draw_text 'X', size: 9, at: [287, pos_y] if params[:afiliado_a_otro_sistema] == "1"
    pdf.draw_text 'X', size: 9, at: [314, pos_y] if params[:afiliado_a_otro_sistema] == "0"
    pdf.text_box params[:codigo_unico], size: 9, width: 50,
            at: [382, pos_y+6], character_spacing: 4.5
    pdf.draw_text 'X', size: 9, at: [99, pos_y-15] if params[:posee_medio_de_acceso] == "1"
    pdf.draw_text 'X', size: 9, at: [127, pos_y-15] if params[:posee_medio_de_acceso] == "0"
    case params[:tipo_medio_acceso]
    when "Dial/Lan"
      pdf.draw_text 'X', size: 9, at: [178, pos_y-15]
    when "GPRS"
      pdf.draw_text 'X', size: 9, at: [219, pos_y-15]
    when "MPOS"
      pdf.draw_text 'X', size: 9, at: [266, pos_y-15]
    end
    case params[:propietario_medio_acceso]
    when "Credibanco"
      pdf.draw_text 'X', size: 9, at: [497, pos_y-15]
    when "Otra red"
      pdf.draw_text 'X', size: 9, at: [546, pos_y-15]
    end

    # Sección exenciones tributarias
    pdf.move_down 32
    pos_y = pdf.cursor
    pdf.draw_text 'X', size: 9, at: [97, pos_y] if params[:exento_de_retencion_de_iva] == "1"
    pdf.draw_text 'X', size: 9, at: [173, pos_y] if params[:exento_de_retencion_de_ica] == "1"
    pdf.draw_text 'X', size: 9, at: [269, pos_y] if params[:exento_de_retencion_en_la_fuente] == "1"
    pdf.draw_text 'X', size: 9, at: [359, pos_y] if params[:requiere_propina] == "1"
    pdf.draw_text 'X', size: 9, at: [390, pos_y] if params[:requiere_propina] == "0"

    # Sección porcentajes de impuestos
    pdf.move_down 15
    pos_y = pdf.cursor
    pdf.draw_text params[:porcentaje_de_iva], size: 9, at: [55, pos_y]
    pdf.draw_text params[:porcentaje_de_reteica], size: 9, at: [145, pos_y]
    pdf.draw_text params[:porcentaje_de_retefuente], size: 9, at: [241, pos_y]
    pdf.draw_text params[:porcentaje_de_impuesto_al_consumo], size: 9, at: [377, pos_y]

    # Sección cuenta bancaria para abonos
    pdf.move_down 36
    pos_y = pdf.cursor
    pdf.text_box params[:numero_de_cuenta], size: 10, width: 100,
            at: [2, pos_y+8], character_spacing: 5.7
    pdf.text_box params[:codigo_banco], size: 10, width: 20,
            at: [188, pos_y+8], character_spacing: 11
    pdf.draw_text params[:nombre_del_banco], size: 9, at: [222, pos_y]
    pdf.text_box params[:codigo_sucursal_banco], size: 10, width: 30,
            at: [511, pos_y+8], character_spacing: 11
    pdf.draw_text params[:titular_cuenta], size: 7, at: [4, pos_y-25]
    pdf.draw_text params[:nit_cc], size: 9, at: [222, pos_y-25]
    case params[:tipo_de_cuenta]
    when "Ahorro"
      pdf.draw_text 'X', size: 8, at: [463, pos_y-12]
    when "Corriente"
      pdf.draw_text 'X', size: 8, at: [512.2, pos_y-12]
    when "Fiduciaria"
      pdf.draw_text 'X', size: 8, at: [558, pos_y-12]
    end
    pdf.draw_text params[:nit_de_la_fiduciaria], size: 9, at: [453, pos_y-24]

    # Sección datos del representante legal
    pdf.move_down 84
    pos_y = pdf.cursor
    pdf.draw_text params[:nombres_y_apellidos_completos_rl], size: 9, at: [127, pos_y-24]
    case params[:tipo_documento_rl]
    when "NIT"
      pdf.draw_text 'X', size: 8, at: [146, pos_y-38]
    when "C.C."
      pdf.draw_text 'X', size: 8, at: [182, pos_y-38]
    when "C.E."
      pdf.draw_text 'X', size: 8, at: [220, pos_y-38]
    end
    pdf.text_box params[:numero_documento_rl], size: 8, width: 60,
            at: [299, pos_y-32], character_spacing: 6.7
    pdf.draw_text ("%02d" % params["fecha_expedicion_documento_rl(3i)"]), size: 9, at: [194, pos_y-50]
    pdf.draw_text ("%02d" % params["fecha_expedicion_documento_rl(2i)"]), size: 9, at: [209, pos_y-50]
    pdf.draw_text params["fecha_expedicion_documento_rl(1i)"], size: 9, at: [224, pos_y-50]
    pdf.draw_text params[:ciudad_expedicion_documento_rl], size: 9, at: [415, pos_y-49]
    pdf.draw_text ("%02d" % params["fecha_de_nacimiento_rl(3i)"]), size: 9, at: [10, pos_y-76]
    pdf.draw_text ("%02d" % params["fecha_de_nacimiento_rl(2i)"]), size: 9, at: [25, pos_y-76]
    pdf.draw_text params["fecha_de_nacimiento_rl(1i)"], size: 9, at: [40, pos_y-76]
    pdf.draw_text params[:ciudad_nacimiento_rl], size: 8, at: [190, pos_y-63]
    pdf.draw_text params[:departamento_nacimiento_rl], size: 7, at: [213, pos_y-76]
    case params[:sexo_rl]
    when "Femenino"
      pdf.draw_text 'X', size: 8, at: [409, pos_y-77]
    when "Masculino"
      pdf.draw_text 'X', size: 8, at: [467, pos_y-77]
    end
    pdf.draw_text params[:direccion_residencia_rl], size: 7, at: [4, pos_y-100]
    pdf.text_box params[:ciudad_residencia_rl], size: 7, width: 80,
            at: [285, pos_y-85]
    pdf.draw_text params[:telefono_rl], size: 9, at: [415, pos_y-100]
    pdf.draw_text params[:correo_electronico_rl], size: 7, at: [4, pos_y-124]
    pdf.draw_text params[:profesion_ocupacion_rl], size: 8, at: [210, pos_y-124]
    pdf.draw_text params[:cargo_rl], size: 8, at: [421, pos_y-124]

    # Sección datos del representante legal
    pdf.move_down 166
    imprimir_datos_socio(pdf, params[:socios_attributes]["0"])
    pdf.move_down 15
    imprimir_datos_socio(pdf, params[:socios_attributes]["1"])
    pdf.move_down 15
    imprimir_datos_socio(pdf, params[:socios_attributes]["2"])

    pdf
  end
  
  private
  
    def self.imprimir_datos_socio(pdf, params)
      pos_y = pdf.cursor
      pdf.draw_text params[:nombres_y_apellidos], size: 7, at: [1, pos_y]
      case params[:tipo_documento]
      when "NIT"
        pdf.draw_text 'NIT', size: 7, at: [127, pos_y]
      when "C.C."
        pdf.draw_text 'C.C.', size: 7, at: [127, pos_y]
      when "C.E."
        pdf.draw_text 'C.E.', size: 7, at: [127, pos_y]
      end
      pdf.draw_text params[:numero_documento], size: 7, at: [150, pos_y]
      pdf.text_box params[:direccion], size: 5, width: 90,
            at: [210, pos_y+8]
      pdf.text_box params[:ciudad], size: 5, width: 60,
            at: [300, pos_y+8]
      pdf.draw_text params[:telefono], size: 7, at: [362, pos_y]
      pdf.draw_text params[:celular], size: 7, at: [410, pos_y]
      pdf.draw_text params[:correo_electronico], size: 6, at: [464, pos_y]
    end
    
    def self.preprocesar(codigos_responsabilidad_tributaria)
      # Primero eliminar los separadores que pueden ser: espacio, guión o coma.
      arreglo = codigos_responsabilidad_tributaria.split((%r{,|-|\s+}))
      # Se retorna un string concatenando las subcadenas del arreglo
      arreglo.join
    end
end