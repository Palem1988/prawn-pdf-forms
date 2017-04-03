class FormularioRedeban
  include Utilitario

  def self.generar(params)
    pdf = Prawn::Document.new(left_margin: 50,
                        top_margin: 50,
                        bottom_margin: 20,
                        page_size: [637.92, 1006.56])
    pdf.move_down 125
    pdf.draw_text params[:razon_social], size: 8, at: [-10, pdf.cursor]
    pdf.draw_text params[:nombre_comercial], size: 8, at: [268, pdf.cursor]
    pdf.text_box params[:numero_documento_comercio], size: 12,
        width: 80, at: [20, pdf.cursor-7], character_spacing: 4.7
    pdf.draw_text params[:digito_de_verificacion], size: 12, at: [150, pdf.cursor-15]
    pdf.text_box params[:codigo_ciiu], size: 12, width: 40,
            at: [55, pdf.cursor-23], character_spacing: 4
    # pdf.text_box params[:codigo_unico], size: 12, width: 70,
    #         at: [433, pdf.cursor-7], character_spacing: 4.7
    pdf.draw_text "X", size: 12, at: [535, pdf.cursor-32] #No adjunta listado de códigos únicos
    pdf.draw_text params[:numero_de_matricula_mercantil], size: 10, at: [140, pdf.cursor-46]

    pdf.move_down 62
    pos_y = pdf.cursor
    case params[:tipo_de_empresa]
    when "Anónima"
      pdf.draw_text 'X', size: 12, at: [60, pos_y-15]
    when "Mixta"
      pdf.draw_text 'X', size: 12, at: [130, pos_y]
    when "Limitada"
      pdf.draw_text 'X', size: 12, at: [60, pos_y]
    when "De hecho"
      pdf.draw_text 'X', size: 12, at: [130, pos_y-15]
    when "Empresa unipersonal"
      pdf.draw_text 'X', size: 12, at: [216, pos_y]
    when "Sociedad cooperativa"
      pdf.draw_text 'X', size: 12, at: [216, pos_y-15]
    when "Colectiva"
      pdf.draw_text 'X', size: 12, at: [293, pos_y]
    when "Comandita simple"
      pdf.draw_text 'X', size: 12, at: [293, pos_y-15]
    when "Comandita por acciones"
      pdf.draw_text 'X', size: 12, at: [391, pos_y]
    when "Sucursales extranjeras"
      pdf.draw_text 'X', size: 12, at: [391, pos_y-15]
    when "Sin ánimo de lucro"
      pdf.draw_text 'X', size: 12, at: [473, pos_y]
    when "Privada extranjera"
      pdf.draw_text 'X', size: 12, at: [473, pos_y-15]
    when "Persona natural"
      pdf.draw_text 'X', size: 12, at: [544, pos_y]
    else
      pdf.draw_text params[:tipo_de_empresa], size: 4, at: [508, pos_y-9]
    end

    # Sección venta de tiquetes
    pdf.move_down 32
    pos_y = pdf.cursor
    case params[:agencia_de_viajes]
    when "Agencia de viajes"
      pdf.draw_text 'X', size: 12, at: [49, pos_y]
    when "Venta propia"
      pdf.draw_text 'X', size: 12, at: [114, pos_y]
    when "Venta propia y de tiquetes"
      pdf.draw_text 'X', size: 12, at: [228, pos_y]
    when "Aerolínea"
      pdf.draw_text 'X', size: 12, at: [410, pos_y]
    end
    unless params[:numero_iata_av].blank?
      pdf.text_box params[:numero_iata_av], size: 12, width: 70,
            at: [275, pos_y+8], character_spacing: 4.7
    end

    case params[:requiere_impuestos_av]
    when "Sí"
      pdf.draw_text 'X', size: 12, at: [518, pos_y]
    when "No"
      pdf.draw_text 'X', size: 12, at: [545, pos_y]
    end

    # Sección responsabilidad tributaria
    pdf.move_down 29
    pos_y = pdf.cursor
    cadena = preprocesar(params[:responsabilidad_tributaria])
    pdf.text_box cadena, size: 12, width: 250,
            at: [144, pos_y+8], character_spacing: 3

    # Sección Dirección del establecimiento
    pdf.move_down 18
    pos_y = pdf.cursor
    pdf.text_box params[:direccion_del_establecimiento], size: 5, at: [97, pos_y+10],
        width: 115
    pdf.draw_text params[:telefono_del_establecimiento], size: 8, at: [250, pos_y]
    ciudad_departamento = params[:ciudad_establecimiento] + " / " + params[:departamento_establecimiento]
    pdf.text_box ciudad_departamento, size: 6, at: [393, pos_y+10],
        width: 170
    pdf.move_down 14
    pos_y = pdf.cursor
    # pdf.text_box params[:direccion_correspondencia], size: 5, at: [97, pos_y+10],
    #     width: 115
    # pdf.draw_text params[:telefono_correspondencia], size: 8, at: [250, pos_y]
    # ciudad_departamento_correspondencia = params[:ciudad_correspondencia] +
    #         " / " + params[:departamento_correspondencia]
    # pdf.text_box ciudad_departamento_correspondencia, size: 6, at: [393, pos_y+10],
    #     width: 170
    pdf.move_down 11
    pos_y = pdf.cursor
    pdf.draw_text params[:celular], size: 8, at: [70, pos_y]
    pdf.draw_text params[:fax], size: 8, at: [250, pos_y]
    pdf.text_box params[:correo_electronico], size: 6, at: [445, pos_y+10],
        width: 110

    # Sección presencia en Internet
    pdf.move_down 15
    pos_y = pdf.cursor
    pdf.draw_text 'X', size: 8, at: [63, pos_y] if params[:facebook] == "1"
    pdf.draw_text 'X', size: 8, at: [110, pos_y] if params[:youtube] == "1"
    pdf.draw_text 'X', size: 8, at: [155, pos_y] if params[:twitter] == "1"
    pdf.draw_text 'X', size: 8, at: [200, pos_y] if params[:linkedin] == "1"
    otras_redes = ""
    otras_redes = 'Foursquare' if params[:foursquare] == "1"
    if params[:flickr] == "1"
      otras_redes << " / " if !otras_redes.blank?
      otras_redes << "Flickr"
    end
    pdf.text_box otras_redes, size: 7, at: [236, pos_y+12], width: 40
    # pdf.text_box params[:nombre_en_redes], size: 7, at: [335, pos_y+12], width: 80
    pdf.text_box params[:direccion_pagina_web], size: 6, at: [458, pos_y+12],
        width: 105

    # Renglón horario de atención
    pdf.move_down 19
    pos_y = pdf.cursor
    case params[:horario_atencion]
    when "Diurno"
      pdf.draw_text 'X', size: 12, at: [58, pos_y]
    when "Nocturno"
      pdf.draw_text 'X', size: 12, at: [109, pos_y]
    when "24 horas"
      pdf.draw_text 'X', size: 12, at: [155, pos_y]
    end
    pdf.draw_text 'X', size: 12, at: [225, pos_y+1] if params[:exento_de_retencion_en_la_fuente] == "1"
    pdf.draw_text 'X', size: 12, at: [250, pos_y+1] if params[:exento_de_retencion_en_la_fuente] == "0"
    pdf.draw_text 'X', size: 12, at: [322, pos_y] if params[:exento_de_retencion_de_ica] == "1"
    pdf.draw_text 'X', size: 12, at: [347, pos_y] if params[:exento_de_retencion_de_ica] == "0"
    pdf.draw_text 'X', size: 12, at: [422, pos_y] if params[:exento_de_retencion_de_iva] == "0"
    pdf.draw_text 'X', size: 12, at: [447, pos_y] if params[:exento_de_retencion_de_iva] == "1"
    pdf.draw_text 'X', size: 12, at: [516, pos_y] if params[:requiere_propina] == "1"
    pdf.draw_text 'X', size: 12, at: [541, pos_y] if params[:requiere_propina] == "0"

    # Renglón tipo de establecimiento
    pdf.move_down 21
    pos_y = pdf.cursor
    case params[:tipo_de_establecimiento]
    when "Principal"
      pdf.draw_text 'X', size: 12, at: [103, pos_y]
    when "Sucursal"
      pdf.draw_text 'X', size: 12, at: [155, pos_y]
    end
    pdf.draw_text params[:porcentaje_de_retefuente], size: 12, at: [173, pos_y-2]
    pdf.draw_text params[:porcentaje_de_reteica], size: 12, at: [277, pos_y-2]
    pdf.draw_text params[:porcentaje_de_iva], size: 12, at: [373, pos_y-2]
    pdf.draw_text params[:porcentaje_de_impuesto_al_consumo], size: 12, at: [472, pos_y-2]

    # Sección certificado cuenta de depósito
    pdf.move_down 64
    pos_y = pdf.cursor
    # pdf.text_box params[:numero_de_cuenta], size: 12,
    #     width: 110, at: [-2, pos_y+8], character_spacing: 4.7
    # pdf.text_box params[:codigo_banco], size: 12,
    #     width: 30, at: [218, pos_y+8], character_spacing: 4.7
    # pdf.draw_text params[:nombre_del_banco], size: 11, at: [284, pos_y]
    # pdf.text_box params[:codigo_sucursal_banco], size: 12,
    #     width: 30, at: [483, pos_y+8], character_spacing: 4.7
    # pdf.text_box params[:titular_cuenta], size: 7, at: [60, pos_y-7],
    #     width: 75
    case params[:tipo_de_cuenta]
    when "Ahorro"
      pdf.draw_text 'X', size: 12, at: [339, pos_y-17]
    when "Corriente"
      pdf.draw_text 'X', size: 12, at: [429, pos_y-17]
    when "Fiduciaria"
      pdf.draw_text 'X', size: 12, at: [524, pos_y-17]
    end
    pdf.draw_text params[:nit_cc], size: 11, at: [18, pos_y-34]
    pdf.draw_text params[:nit_de_la_fiduciaria], size: 11, at: [284, pos_y-34]

    # Sección datos de los socios con participación superior a 5%
    pdf.move_down 240
    # imprimir_datos_socio(pdf, params[:socios_attributes]["0"])
    pdf.move_down 32
    # imprimir_datos_socio(pdf, params[:socios_attributes]["1"])

    # Sección referencias comerciales del establecimiento
    pdf.move_down 41
    imprimir_referencia_comercial(pdf, params[:referencias_comerciales_attributes]["0"])
    pdf.move_down 14
    imprimir_referencia_comercial(pdf, params[:referencias_comerciales_attributes]["1"])

    # Sección datos del representante legal
    pdf.move_down 34
    pos_y = pdf.cursor
    pdf.draw_text params[:nombres_rl], size: 9, at: [-15, pos_y]
    pdf.draw_text params[:primer_apellido_rl], size: 9, at: [145, pos_y]
    pdf.draw_text params[:segundo_apellido_rl], size: 9, at: [344, pos_y]
    pdf.move_down 15
    pos_y = pdf.cursor
    case params[:tipo_documento_rl]
    when "NIT"
      pdf.draw_text 'X', size: 11, at: [60, pos_y]
    when "C.C."
      pdf.draw_text 'X', size: 11, at: [150, pos_y]
    when "C.E."
      pdf.draw_text 'X', size: 11, at: [96, pos_y-12]
    end
    pdf.text_box params[:numero_documento_rl], size: 12,
        width: 100, at: [179, pos_y+9], character_spacing: 4.7
    fecha_expedicion_documento_rl = "%02d" % params["fecha_expedicion_documento_rl(3i)"]
    fecha_expedicion_documento_rl << "%02d" % params["fecha_expedicion_documento_rl(2i)"]
    fecha_expedicion_documento_rl << params["fecha_expedicion_documento_rl(1i)"]
    pdf.text_box fecha_expedicion_documento_rl, size: 12,
        width: 80, at: [224, pos_y-4], character_spacing: 4.7
    fecha_de_nacimiento_rl = "%02d" % params["fecha_de_nacimiento_rl(3i)"]
    fecha_de_nacimiento_rl << "%02d" % params["fecha_de_nacimiento_rl(2i)"]
    fecha_de_nacimiento_rl << params["fecha_de_nacimiento_rl(1i)"]
    pdf.text_box fecha_de_nacimiento_rl, size: 12,
        width: 80, at: [320, pos_y-6], character_spacing: 5.7
    pdf.draw_text params[:ciudad_nacimiento_rl], size: 6, at: [448, pos_y+5]
    pdf.draw_text params[:departamento_nacimiento_rl], size: 6, at: [475, pos_y-8]
    pdf.move_down 30
    pos_y = pdf.cursor
    case params[:sexo_rl]
    when "Femenino"
      pdf.draw_text 'X', size: 12, at: [14, pos_y]
    when "Masculino"
      pdf.draw_text 'X', size: 12, at: [40, pos_y]
    end
    case params[:estado_civil]
    when "Soltero"
      pdf.draw_text 'X', size: 12, at: [132, pos_y]
    when "Casado"
      pdf.draw_text 'X', size: 12, at: [172, pos_y]
    when "Divorciado"
      pdf.draw_text 'X', size: 12, at: [225, pos_y]
    when "Separado"
      pdf.draw_text 'X', size: 12, at: [275, pos_y]
    when "Viudo"
      pdf.draw_text 'X', size: 12, at: [309, pos_y]
    when "Unión libre"
      pdf.draw_text 'X', size: 12, at: [361, pos_y]
    when "Religioso"
      pdf.draw_text 'X', size: 12, at: [408, pos_y]
    end
    pdf.text_box params[:correo_electronico_rl], size: 7, width: 115,
            at: [445, pos_y+12]
    pdf.move_down 21
    pos_y = pdf.cursor
    pdf.draw_text params[:direccion_residencia_rl], size: 7, at: [-15, pos_y]
    pdf.text_box params[:ciudad_residencia_rl], size: 7, width: 75,
      at: [235, pos_y+13]
    pdf.draw_text params[:telefono_rl], size: 11, at: [312, pos_y]
    pdf.draw_text params[:celular_rl], size: 11, at: [435, pos_y]
    pdf.move_down 17
    pos_y = pdf.cursor
    pdf.draw_text params[:profesion_ocupacion_rl], size: 6, at: [-15, pos_y]
    case params[:tipo_profesion_rl]
    when "Independiente"
      pdf.draw_text 'X', size: 12, at: [138, pos_y+3]
    when "Empleado"
      pdf.draw_text 'X', size: 12, at: [187, pos_y+3]
    when "Servidor público"
      pdf.draw_text 'X', size: 12, at: [261, pos_y+3]
    when "Socios"
      pdf.draw_text 'X', size: 12, at: [299, pos_y+3]
    when "Estudiante"
      pdf.draw_text 'X', size: 12, at: [350, pos_y+3]
    when "Ama de casa"
      pdf.draw_text 'X', size: 12, at: [406, pos_y+3]
    when "Pensionado"
      pdf.draw_text 'X', size: 12, at: [460, pos_y+3]
    end
    pdf.draw_text params[:cargo_rl], size: 6, at: [473, pos_y]
    pdf.move_down 17
    pos_y = pdf.cursor
    pdf.draw_text 'X', size: 12, at: [118, pos_y] if params[:administra_recursos_publicos_rl] == "1"
    pdf.draw_text 'X', size: 12, at: [150, pos_y] if params[:administra_recursos_publicos_rl] == "0"
    pdf.draw_text 'X', size: 12, at: [334, pos_y] if params[:ostenta_algun_grado_de_poder_publico_rl] == "1"
    pdf.draw_text 'X', size: 12, at: [362, pos_y] if params[:ostenta_algun_grado_de_poder_publico_rl] == "0"
    pdf.draw_text 'X', size: 12, at: [520, pos_y] if params[:goza_de_reconocimiento_publico_rl] == "1"
    pdf.draw_text 'X', size: 12, at: [548, pos_y] if params[:goza_de_reconocimiento_publico_rl] == "0"

    # Sección referencias personales del representante legal
    pdf.move_down 44
    imprimir_referencia_personal(pdf, params[:referencias_personales_attributes]["0"])
    pdf.move_down 15
    imprimir_referencia_personal(pdf, params[:referencias_personales_attributes]["1"])

    # Segunda página
    pdf.start_new_page

    # Sección información económica del establecimiento
    pdf.move_down 8
    pos_y = pdf.cursor
    pdf.draw_text params[:ingresos_operacionales], size: 11, at: [-5, pos_y]
    pdf.draw_text params[:ingresos_mensuales], size: 11, at: [137, pos_y]
    pdf.draw_text params[:egresos_mensuales], size: 11, at: [271, pos_y]
    pdf.draw_text params[:total_activos], size: 11, at: [393, pos_y]
    pdf.draw_text params[:total_pasivos], size: 11, at: [484, pos_y]
    case params[:operaciones_internacionales]
    when "Sí"
      pdf.draw_text 'X', size: 12, at: [78, pos_y-18]
    when "No"
      pdf.draw_text 'X', size: 12, at: [78, pos_y-31.5]
    end
    pdf.draw_text 'X', size: 12, at: [343, pos_y-18] if params[:importacion_oi] == "1"
    pdf.draw_text 'X', size: 12, at: [484, pos_y-18] if params[:prestamos_oi] == "1"
    pdf.draw_text 'X', size: 12, at: [343, pos_y-31.5] if params[:exportacion_oi] == "1"
    pdf.draw_text 'X', size: 12, at: [425, pos_y-18] if params[:pago_de_servicios_oi] == "1"
    pdf.draw_text 'X', size: 12, at: [549, pos_y-18] if params[:inversiones_oi] == "1"

    pdf
  end

  private

    def self.imprimir_datos_socio(pdf, params)
      pos_y = pdf.cursor
      pdf.draw_text params[:nombres_y_apellidos], size: 8, at: [-15, pos_y]
      pdf.text_box params[:porcentaje_participacion], size: 12,
          width: 30, at: [154, pos_y+12], character_spacing: 4.5, align: :right
      case params[:tipo_documento]
      when "NIT"
        pdf.draw_text 'NIT', size: 7, at: [127, pos_y]
      when "C.C."
        pdf.draw_text 'X', size: 12, at: [192, pos_y]
      when "C.E."
        pdf.draw_text 'X', size: 12, at: [209, pos_y]
      end
      pdf.draw_text params[:numero_documento], size: 11, at: [225, pos_y+15]
      pdf.text_box params[:ciudad], size: 8, width: 85,
            at: [396, pos_y+30]
      pdf.draw_text params[:telefono], size: 11, at: [480, pos_y+15]
      pdf.draw_text params[:celular], size: 9, at: [225, pos_y]
      pdf.text_box params[:direccion], size: 6, width: 120,
            at: [445, pos_y+12]
    end

    def self.imprimir_referencia_comercial(pdf, params)
      pos_y = pdf.cursor
      pdf.draw_text params[:nombres_y_apellidos], size: 8, at: [-15, pos_y]
      pdf.draw_text params[:numero_identificacion], size: 11, at: [145, pos_y]
      pdf.text_box params[:direccion], size: 6, width: 120,
            at: [235, pos_y+11]
      pdf.text_box params[:ciudad], size: 7, width: 100, leading: -2,
            at: [361, pos_y+11]
      pdf.draw_text params[:telefono], size: 11, at: [459, pos_y]
    end

    def self.imprimir_referencia_personal(pdf, params)
      pos_y = pdf.cursor
      pdf.draw_text params[:nombres_y_apellidos], size: 8, at: [-15, pos_y]
      pdf.text_box params[:direccion], size: 7, width: 140, leading: -2,
            at: [193, pos_y+11]
      pdf.text_box params[:ciudad], size: 7, width: 110, leading: -2,
            at: [334, pos_y+11]
      pdf.draw_text params[:telefono], size: 11, at: [446, pos_y]
    end
end
