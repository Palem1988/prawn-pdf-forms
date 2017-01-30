class FormCredibanco
  include Utilitario

  def self.generar(params)
    pdf = Prawn::Document.new(left_margin: 78,
                        top_margin:10,
                        page_size: "LETTER")
    pdf.move_down 36
    pdf.draw_text 'X', size: 5, at: [18, pdf.cursor]
    pdf.draw_text 'X', size: 5, at: [79, pdf.cursor-79]

    pdf.move_down 108
    pdf.draw_text 'CCI*' + params[:razon_social], size: 9, at: [4, pdf.cursor]

    pdf.move_down 20
    case params[:tipo_documento_comercio]
    when "NIT"
      pdf.draw_text 'X', size: 5, at: [19, pdf.cursor]
    when "C.C."
      pdf.draw_text 'X', size: 5, at: [46, pdf.cursor]
    when "C.E."
      pdf.draw_text 'X', size: 5, at: [71, pdf.cursor]
    end

    pdf.text_box params[:numero_documento_comercio], size: 7, at: [99, pdf.cursor+5.5], 
    character_spacing: 3.7
    pdf.text_box params[:numero_de_matricula_mercantil], size: 7, at: [280, pdf.cursor+5.5], 
    character_spacing: 3.7
    # unless params[:numero_de_matricula_mercantil].blank?
    #   pdf.draw_text 'X', size: 10, at: [325, pdf.cursor]
    #   pdf.text_box params[:numero_de_matricula_mercantil], size: 10, width: 60,
    #         at: [356, pdf.cursor+8], character_spacing: 4
    # end

    pdf.move_down 22
    pos_y = pdf.cursor
    case params[:tipo_de_empresa]
    when "Anónima"
      pdf.draw_text 'X', size: 5, at: [31, pos_y]
    when "S.A.S."
      pdf.draw_text 'X', size: 5, at: [63, pos_y]
    when "Pública"
      pdf.draw_text 'X', size: 5, at: [102, pos_y]
    when "Mixta"
      pdf.draw_text 'X', size: 5, at: [133, pos_y]
    when "Limitada"
      pdf.draw_text 'X', size: 5, at: [31, pos_y-10]
    when "Sin ánimo de lucro"
      pdf.draw_text 'X', size: 5, at: [96, pos_y-10]
    when "Privada"
      pdf.draw_text 'X', size: 5, at: [134, pos_y-10]
    else
      pdf.draw_text 'X', size: 5, at: [168, pos_y-10]
      pdf.draw_text params[:tipo_de_empresa], size: 9, at: [206, pos_y-9]
    end

    case params[:naturaleza]
    when "Jurídica"
      pdf.draw_text 'X', size: 5, at: [375, pos_y]
    when "Natural"
      pdf.draw_text 'X', size: 5, at: [375, pos_y-10]
    end

    # Sección venta de tiquetes
    pdf.move_down 22
    pos_y = pdf.cursor
    case params[:agencia_de_viajes]
    when "Agencia de viajes"
      pdf.draw_text 'X', size: 5, at: [53, pos_y]
    when "Venta propia"
      pdf.draw_text 'X', size: 5, at: [102, pos_y]
    when "Venta propia y de tiquetes"
      pdf.draw_text 'X', size: 5, at: [184, pos_y]
    when "Aerolínea"
      pdf.draw_text 'X', size: 5, at: [317, pos_y]
    end
    unless params[:numero_iata_av].blank?
      pdf.text_box params[:numero_iata_av], size: 7, at: [217, pos_y+5], character_spacing: 3.7
    end

    case params[:requiere_impuestos_av]
    when "Sí"
      pdf.draw_text 'X', size: 5, at: [394, pos_y]
    when "No"
      pdf.draw_text 'X', size: 5, at: [415, pos_y]
    end

    # Sección actividad comercial y responsabilidad tributaria
    pdf.move_down 12
    pos_y = pdf.cursor
    pdf.draw_text params[:actividad_comercial], size: 9, at: [61, pos_y]
    cadena = preprocesar(params[:responsabilidad_tributaria])
    pdf.text_box cadena, size: 10, width: 210,
            at: [7, pos_y+17-40], character_spacing: 2.3
    pdf.text_box params[:codigo_ciiu], size: 7, at: [327, pos_y+26-40], character_spacing: 3.7
    pdf.text_box params[:mcc], size: 7, at: [327, pos_y+16-40], character_spacing: 3.7




    # Sección Tipo de afiliación
    pdf.move_down 40
    pos_y = pdf.cursor
    # pdf.draw_text 'X', size: 10, at: [86, pos_y] if params[:venta_presencial_ta] == "1"
    # pdf.draw_text 'X', size: 10, at: [149, pos_y] if params[:mi_pago_ta] == "1"
    # pdf.draw_text 'X', size: 10, at: [60, pos_y-25] if params[:multicomercio_ta] == "1"
    # case params[:comercio_principal_secundario_ta]
    # when "Principal"
    #   pdf.draw_text 'X', size: 10, at: [149, pos_y-25]
    # when "Secundario"
    #   pdf.draw_text 'X', size: 10, at: [245, pos_y-25]
    # end




    # Sección Venta No Presencial
    pdf.move_down 44
    pos_y = pdf.cursor
    pdf.draw_text 'X', size: 5, at: [64, pos_y] if params[:venta_no_presencial] == "1"
    # pdf.draw_text 'X', size: 10, at: [78, pos_y-12] if params[:paga_cuentas] == "1"
    pdf.draw_text 'X', size: 5, at: [186, pos_y-2] if params[:visa_distribucion] == "1"
    # pdf.draw_text 'X', size: 10, at: [294, pos_y-12] if params[:pse] == "1"
    # pdf.draw_text 'X', size: 10, at: [78, pos_y-24] if params[:web_de_pagos] == "1"
    # pdf.draw_text 'X', size: 10, at: [150, pos_y-24] if params[:recurrente] == "1"
    # pdf.draw_text 'X', size: 10, at: [180, pos_y-24] if params[:api] == "1"
    # pdf.draw_text 'X', size: 10, at: [256, pos_y-24] if params[:boton_de_pagos] == "1"
    # pdf.draw_text 'X', size: 10, at: [324, pos_y-24] if params[:mall_virtual] == "1"
    # pdf.draw_text 'X', size: 10, at: [527, pos_y-12] if params[:modulo_basico_afs] == "1"
    # pdf.draw_text 'X', size: 10, at: [527, pos_y-24] if params[:modulo_avanzado_cybersource] == "1"

    # Sección Dirección del establecimiento
    pdf.move_down 27
    pos_y = pdf.cursor
    pdf.text_box params[:direccion_del_establecimiento], size: 6, width: 134, leading: -2,
            at: [2, pos_y+10]
    # pdf.draw_text params[:direccion_del_establecimiento], size: 7, at: [2, pos_y]
    pdf.draw_text params[:telefono_del_establecimiento], size: 7, at: [137, pos_y]
    pdf.draw_text params[:celular], size: 7, at: [224, pos_y]
    pdf.draw_text params[:fax], size: 7, at: [309, pos_y]
    pdf.text_box params[:codigo_ciudad], size: 7, at: [400, pos_y+16.5], character_spacing: 3.7
    pdf.text_box params[:codigo_departamento], size: 7, at: [400, pos_y+7], character_spacing: 3.7

    # Sección Dirección de correspondencia/notificaciones
    pdf.move_down 20
    pos_y = pdf.cursor

    # Direccion en 2 espacios
    pdf.text_box params[:direccion_correspondencia], size: 6, width: 134, leading: -2,
            at: [2, pos_y+10]
    # pdf.draw_text params[:direccion_correspondencia], size: 7, at: [2, pos_y]
    pdf.draw_text params[:telefono_correspondencia], size: 7, at: [137, pos_y]
    # ciudad_departamento_correspondencia = params[:ciudad_correspondencia] +
    #         " / " + params[:departamento_correspondencia]
    pdf.draw_text params[:ciudad_correspondencia], size: 7, at: [224, pos_y]

    case params[:horario_atencion]
    when "Diurno"
      pdf.draw_text 'X', size: 5, at: [334, pos_y+1]
    when "Nocturno"
      pdf.draw_text 'X', size: 5, at: [374, pos_y+1]
    when "24 horas"
      pdf.draw_text 'X', size: 5, at: [412, pos_y+1]
    end

    # Sección presencia en Internet
    pdf.text_box params[:correo_electronico], size: 6, width: 134, leading: -2,
            at: [2, pos_y-11]
    # pdf.text_box params[:correo_electronico], size: 8, at: [2, pos_y-16],
    #     width: 160
    pdf.draw_text 'X', size: 5, at: [401, pos_y-20]
    # pdf.text_box params[:direccion_pagina_web], size: 7, at: [175, pos_y-16],
    #     width: 160
    # pdf.draw_text 'X', size: 9, at: [463, pos_y-13] if params[:facebook] == "1"
    # pdf.draw_text 'X', size: 9, at: [510, pos_y-13] if params[:twitter] == "1"
    # pdf.draw_text 'X', size: 9, at: [557.5, pos_y-13] if params[:youtube] == "1"
    # pdf.draw_text 'X', size: 9, at: [351, pos_y-27] if params[:foursquare] == "1"
    # pdf.draw_text 'X', size: 9, at: [391, pos_y-27] if params[:flickr] == "1"
    # pdf.draw_text 'Linkedin', size: 9, at: [454, pos_y-24] if params[:linkedin] == "1"

    # Sección tipo de establecimiento
    pdf.move_down 33
    pos_y = pdf.cursor
    case params[:tipo_de_establecimiento]
    when "Principal"
      pdf.draw_text 'X', size: 5, at: [103, pos_y]
    when "Sucursal"
      pdf.draw_text 'X', size: 5, at: [143, pos_y]
    end
    pdf.draw_text 'X', size: 5, at: [227, pos_y] if params[:afiliado_a_otro_sistema] == "1"
    pdf.draw_text 'X', size: 5, at: [250, pos_y] if params[:afiliado_a_otro_sistema] == "0"
    pdf.text_box params[:codigo_unico], width: 50, size: 7, at: [301, pos_y+6], character_spacing: 3.7
    pdf.draw_text 'X', size: 5, at: [80, pos_y-11] if params[:posee_medio_de_acceso] == "1"
    pdf.draw_text 'X', size: 5, at: [102, pos_y-11] if params[:posee_medio_de_acceso] == "0"
    case params[:tipo_medio_acceso]
    when "Dial/Lan"
      pdf.draw_text 'X', size: 5, at: [143, pos_y-11]
    when "GPRS"
      pdf.draw_text 'X', size: 5, at: [173, pos_y-11]
    when "MPOS"
      pdf.draw_text 'X', size: 5, at: [213, pos_y-11]
    end
    case params[:propietario_medio_acceso]
    when "Credibanco"
      pdf.draw_text 'X', size: 5, at: [390, pos_y-11]
    when "Otra red"
      pdf.draw_text 'X', size: 5, at: [431, pos_y-11]
    end

    # Sección exenciones tributarias
    # pdf.move_down 32
    # pos_y = pdf.cursor
    # pdf.draw_text 'X', size: 9, at: [97, pos_y] if params[:exento_de_retencion_de_iva] == "1"
    # pdf.draw_text 'X', size: 9, at: [173, pos_y] if params[:exento_de_retencion_de_ica] == "1"
    # pdf.draw_text 'X', size: 9, at: [269, pos_y] if params[:exento_de_retencion_en_la_fuente] == "1"
    # pdf.draw_text 'X', size: 9, at: [359, pos_y] if params[:requiere_propina] == "1"
    # pdf.draw_text 'X', size: 9, at: [390, pos_y] if params[:requiere_propina] == "0"

    # # Sección porcentajes de impuestos
    # pdf.move_down 15
    # pos_y = pdf.cursor
    # pdf.draw_text params[:porcentaje_de_iva], size: 9, at: [55, pos_y]
    # pdf.draw_text params[:porcentaje_de_reteica], size: 9, at: [145, pos_y]
    # pdf.draw_text params[:porcentaje_de_retefuente], size: 9, at: [241, pos_y]
    # pdf.draw_text params[:porcentaje_de_impuesto_al_consumo], size: 9, at: [377, pos_y]

    # Sección cuenta bancaria para abonos
    pdf.move_down 79
    pos_y = pdf.cursor

    pdf.text_box "3167041513", size: 10, width: 100, at: [2, pdf.cursor+8], character_spacing: 3.4
    pdf.text_box "07", size: 10, width: 100, at: [151, pdf.cursor+8], character_spacing: 3.8
    pdf.draw_text "Bancolombia", size: 9, at: [182, pdf.cursor+1]
    pdf.draw_text 'Central Comercializadora de Internet SAS', size: 9, at: [2, pdf.cursor-20]
    pdf.draw_text '900293637-2', size: 9, at: [182, pdf.cursor-20]
    pdf.draw_text 'X', size: 5, at: [404, pdf.cursor-8]


    # pdf.text_box params[:numero_de_cuenta], size: 10, width: 100,
    #         at: [2, pos_y+8], character_spacing: 5.7
    # pdf.text_box params[:numero_de_cuenta], size: 10, width: 100,
    #         at: [2, pos_y+8], character_spacing: 5.7
    # pdf.text_box params[:codigo_banco], size: 10, width: 20,
    #         at: [188, pos_y+8], character_spacing: 11
    # pdf.draw_text params[:nombre_del_banco], size: 9, at: [222, pos_y]
    # pdf.text_box params[:codigo_sucursal_banco], size: 10, width: 30,
    #         at: [511, pos_y+8], character_spacing: 11
    # pdf.draw_text params[:titular_cuenta], size: 7, at: [4, pos_y-25]
    # pdf.draw_text params[:nit_cc], size: 9, at: [222, pos_y-25]
    # case params[:tipo_de_cuenta]
    # when "Ahorro"
    #   pdf.draw_text 'X', size: 8, at: [463, pos_y-12]
    # when "Corriente"
    #   pdf.draw_text 'X', size: 8, at: [512.2, pos_y-12]
    # when "Fiduciaria"
    #   pdf.draw_text 'X', size: 8, at: [558, pos_y-12]
    # end
    # pdf.draw_text params[:nit_de_la_fiduciaria], size: 9, at: [453, pos_y-24]



    # Sección datos del representante legal
    pdf.move_down 84
    pos_y = pdf.cursor
    nombres_y_apellidos_rl = params[:nombres_rl] + " " + params[:primer_apellido_rl]
    nombres_y_apellidos_rl << " " + params[:segundo_apellido_rl]

    pdf.draw_text nombres_y_apellidos_rl, size: 9, at: [88, pos_y-4]
    case params[:tipo_documento_rl]
    when "NIT"
      pdf.draw_text 'X', size: 8, at: [115, pos_y-20]
    when "C.C."
      pdf.draw_text 'X', size: 8, at: [145, pos_y-20]
    when "C.E."
      pdf.draw_text 'X', size: 8, at: [173, pos_y-20]
    end


    pdf.text_box params[:numero_documento_rl], size: 7, width: 60,
            at: [236, pos_y-14], character_spacing: 4.7

    pdf.draw_text ("%02d" % params["fecha_expedicion_documento_rl(3i)"]), size: 7, at: [154, pos_y-29]
    pdf.draw_text ("%02d" % params["fecha_expedicion_documento_rl(2i)"]), size: 7, at: [167, pos_y-29]
    pdf.draw_text params["fecha_expedicion_documento_rl(1i)"], size: 7, at: [179, pos_y-29]
    pdf.draw_text params[:ciudad_expedicion_documento_rl], size: 7, at: [324, pos_y-28]

    pdf.draw_text ("%02d" % params["fecha_de_nacimiento_rl(3i)"]), size: 7, at: [10, pos_y-50]
    pdf.draw_text ("%02d" % params["fecha_de_nacimiento_rl(2i)"]), size: 7, at: [25, pos_y-50]
    pdf.draw_text params["fecha_de_nacimiento_rl(1i)"], size: 7, at: [40, pos_y-50]

    pdf.draw_text params[:ciudad_nacimiento_rl], size: 6.5, at: [185, pos_y-40]
    pdf.draw_text params[:departamento_nacimiento_rl], size: 6.5, at: [204, pos_y-50]

    case params[:sexo_rl]
    when "Femenino"
      pdf.draw_text 'X', size: 8, at: [322, pos_y-50]
    when "Masculino"
      pdf.draw_text 'X', size: 8, at: [367, pos_y-50]
    end

    pdf.text_box params[:direccion_residencia_rl], size: 6, width: 190, leading: -2,
            at: [3, pos_y-62]
    # pdf.draw_text params[:direccion_residencia_rl], size: 7, at: [3, pos_y-72]
    pdf.text_box params[:ciudad_residencia_rl], size: 6, width: 80,
            at: [201, pos_y-67]
    pdf.draw_text params[:telefono_rl], size: 7, at: [300, pos_y-71]
    pdf.text_box params[:correo_electronico_rl], size: 6.5, width: 154, leading: -2,
            at: [3, pos_y-83]
    # pdf.draw_text params[:correo_electronico_rl], size: 7, at: [3, pos_y-95]
    pdf.draw_text params[:profesion_ocupacion_rl], size: 7, at: [160, pos_y-95]
    pdf.draw_text params[:cargo_rl], size: 7, at: [331, pos_y-95]

    # # Sección datos de los socios con participación superior a 5%
    # pdf.move_down 166
    # imprimir_datos_socio(pdf, params[:socios_attributes]["0"])
    # pdf.move_down 15
    # imprimir_datos_socio(pdf, params[:socios_attributes]["1"])
    # pdf.move_down 15
    # imprimir_datos_socio(pdf, params[:socios_attributes]["2"])

    # # Sección referencias personales del propietario
    # pdf.move_down 51
    # imprimir_referencia(pdf, params[:referencias_personales_attributes]["0"])
    # pdf.move_down 12
    # imprimir_referencia(pdf, params[:referencias_personales_attributes]["1"])

    # # Sección referencias comerciales del establecimiento
    # pdf.move_down 34
    # imprimir_referencia(pdf, params[:referencias_comerciales_attributes]["0"])
    # pdf.move_down 12
    # imprimir_referencia(pdf, params[:referencias_comerciales_attributes]["1"])

    # Segunda página
    pdf.start_new_page


    # Sección información financiera
    pdf.move_down 20
    pos_y = pdf.cursor

    pdf.draw_text "5.000.000", size: 9, at: [70, pos_y]
    pdf.draw_text "3.000.000", size: 9, at: [370, pos_y]
    pdf.draw_text "10.000.000", size: 9, at: [70, pos_y-10]
    pdf.draw_text "3.000.000", size: 9, at: [210, pos_y-10]
    pdf.draw_text 'X', size: 5, at: [48, pos_y-41]
    

    # pdf.draw_text params[:ingresos_mensuales], size: 9, at: [80, pos_y-5]
    # pdf.draw_text params[:otros_ingresos], size: 9, at: [243, pos_y-5]
    # pdf.draw_text params[:egresos_mensuales], size: 9, at: [445, pos_y-5]
    # pdf.draw_text params[:total_activos], size: 9, at: [58, pos_y-18]
    # pdf.draw_text params[:total_pasivos], size: 9, at: [243, pos_y-18]
    # case params[:operaciones_internacionales]
    # when "Sí"
    #   pdf.draw_text 'X', size: 7, at: [16, pos_y-58]
    # when "No"
    #   pdf.draw_text 'X', size: 7, at: [57, pos_y-58]
    # end
    #numero = NumeroString.new(params[:monto_estimado_mensual_oi])
    # pdf.draw_text params[:monto_estimado_mensual_oi], size: 9, at: [15, pos_y-104]
    # pdf.draw_text 'X', size: 9, at: [241, pos_y-56] if params[:importacion_oi] == "1"
    # pdf.draw_text 'X', size: 9, at: [241, pos_y-68] if params[:prestamos_oi] == "1"
    # pdf.draw_text 'X', size: 9, at: [241, pos_y-80] if params[:exportacion_oi] == "1"
    # pdf.draw_text 'X', size: 9, at: [241, pos_y-93] if params[:pago_de_servicios_oi] == "1"
    # pdf.draw_text 'X', size: 9, at: [241, pos_y-106] if params[:inversiones_oi] == "1"

    #Firma del representante legal
    pdf.move_down 342
    pos_y = pdf.cursor
    pdf.draw_text nombres_y_apellidos_rl, size: 6, at: [240, pos_y]
    pdf.draw_text params[:numero_documento_rl], size: 6, at: [240, pos_y-7.5]

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

    def self.imprimir_referencia(pdf, params)
      pos_y = pdf.cursor
      pdf.draw_text params[:nombres_y_apellidos], size: 7, at: [1, pos_y]
      pdf.text_box params[:direccion], size: 5, width: 120,
            at: [132, pos_y+8]
      pdf.text_box params[:ciudad], size: 5, width: 70,
            at: [251, pos_y+8]
      pdf.draw_text params[:telefono], size: 7, at: [322, pos_y]
      pdf.draw_text params[:celular], size: 7, at: [376, pos_y]
      pdf.draw_text params[:correo_electronico], size: 6, at: [435, pos_y]
    end

end
