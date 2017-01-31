class FormRedeban
  include Utilitario

  def self.generar(params)
    pdf = Prawn::Document.new(left_margin: 85,
                        top_margin: 50,
                        bottom_margin: 20,
                        page_size: "LETTER")
    pdf.move_down 95
    pdf.draw_text "CCI*" + params[:razon_social], size: 6, at: [2, pdf.cursor]
    pdf.draw_text params[:nombre_comercial], size: 6, at: [228, pdf.cursor]

    pdf.text_box params[:numero_documento_comercio], size: 10,
        width: 80, at: [25, pdf.cursor-4], character_spacing: 3.5
    pdf.draw_text params[:digito_de_verificacion], size: 10, at: [128, pdf.cursor-11]
    pdf.text_box params[:codigo_ciiu], size: 10, width: 40,
            at: [52, pdf.cursor-17], character_spacing: 3.6

    pdf.text_box params[:codigo_unico], size: 10, width: 70,
            at: [349.5, pdf.cursor-4], character_spacing: 3.5
    pdf.draw_text "X", size: 10, at: [430, pdf.cursor-24] #No adjunta listado de códigos únicos
    pdf.draw_text params[:numero_de_matricula_mercantil], size: 8, at: [125, pdf.cursor-35]

    pdf.move_down 48
    pos_y = pdf.cursor
    case params[:tipo_de_empresa]
    when "Anónima"
      pdf.draw_text 'X', size: 10, at: [56, pos_y-11]
    when "Mixta"
      pdf.draw_text 'X', size: 10, at: [111, pos_y]
    when "Limitada"
      pdf.draw_text 'X', size: 10, at: [56, pos_y]
    when "De hecho"
      pdf.draw_text 'X', size: 10, at: [111, pos_y-11]
    when "Empresa unipersonal"
      pdf.draw_text 'X', size: 10, at: [179, pos_y]
    when "Sociedad cooperativa"
      pdf.draw_text 'X', size: 10, at: [179, pos_y-11]
    when "Colectiva"
      pdf.draw_text 'X', size: 10, at: [240, pos_y]
    when "Comandita simple"
      pdf.draw_text 'X', size: 10, at: [240, pos_y-11]
    when "Comandita por acciones"
      pdf.draw_text 'X', size: 10, at: [317, pos_y]
    when "Sucursales extranjeras"
      pdf.draw_text 'X', size: 10, at: [317, pos_y-11]
    when "Sin ánimo de lucro"
      pdf.draw_text 'X', size: 10, at: [380, pos_y]
    when "Privada extranjera"
      pdf.draw_text 'X', size: 10, at: [380, pos_y-11]
    when "Persona natural"
      pdf.draw_text 'X', size: 10, at: [436, pos_y]
    else
      pdf.draw_text params[:tipo_de_empresa], size: 4, at: [410, pos_y-5]
    end

    # Sección venta de tiquetes
    # pdf.move_down 32
    # pos_y = pdf.cursor
    # case params[:agencia_de_viajes]
    # when "Agencia de viajes"
    #   pdf.draw_text 'X', size: 12, at: [49, pos_y]
    # when "Venta propia"
    #   pdf.draw_text 'X', size: 12, at: [114, pos_y]
    # when "Venta propia y de tiquetes"
    #   pdf.draw_text 'X', size: 12, at: [228, pos_y]
    # when "Aerolínea"
    #   pdf.draw_text 'X', size: 12, at: [410, pos_y]
    # end
    # unless params[:numero_iata_av].blank?
    #   pdf.text_box params[:numero_iata_av], size: 12, width: 70,
    #         at: [275, pos_y+8], character_spacing: 4.7
    # end

    # case params[:requiere_impuestos_av]
    # when "Sí"
    #   pdf.draw_text 'X', size: 12, at: [518, pos_y]
    # when "No"
    #   pdf.draw_text 'X', size: 12, at: [545, pos_y]
    # end

    # Sección responsabilidad tributaria
    pdf.move_down 43
    pos_y = pdf.cursor
    cadena = preprocesar(params[:responsabilidad_tributaria])
    pdf.text_box cadena, size: 10, width: 250,
            at: [122.5, pos_y+7], character_spacing: 2.1

    # Sección Dirección del establecimiento
    pdf.move_down 12
    pos_y = pdf.cursor
    pdf.text_box params[:direccion_del_establecimiento], size: 4.5, at: [85, pos_y+7],
        width: 85
    pdf.draw_text params[:telefono_del_establecimiento], size: 5, at: [203, pos_y]
    ciudad_departamento = params[:ciudad_establecimiento] + " / " + params[:departamento_establecimiento]
    pdf.text_box ciudad_departamento, size: 5, at: [319, pos_y+4],
        width: 170

    pdf.move_down 11
    pos_y = pdf.cursor
    pdf.text_box params[:direccion_correspondencia], size: 5, at: [85, pos_y+8],
        width: 85
    pdf.draw_text params[:telefono_correspondencia], size: 5, at: [203, pos_y]
    ciudad_departamento_correspondencia = params[:ciudad_correspondencia] +
            " / " + params[:departamento_correspondencia]
    pdf.text_box ciudad_departamento_correspondencia, size: 6, at: [319, pos_y+5],
        width: 170
    pdf.move_down 11
    pos_y = pdf.cursor
    pdf.draw_text params[:celular], size: 6, at: [50, pos_y+1]
    pdf.draw_text params[:fax], size: 5, at: [187, pos_y+1]
    pdf.text_box params[:correo_electronico], size: 5, at: [357, pos_y+9.5],
        width: 93

    # Sección presencia en Internet
    # pdf.move_down 15
    # pos_y = pdf.cursor
    # pdf.draw_text 'X', size: 8, at: [63, pos_y] if params[:facebook] == "1"
    # pdf.draw_text 'X', size: 8, at: [110, pos_y] if params[:youtube] == "1"
    # pdf.draw_text 'X', size: 8, at: [155, pos_y] if params[:twitter] == "1"
    # pdf.draw_text 'X', size: 8, at: [200, pos_y] if params[:linkedin] == "1"
    # otras_redes = ""
    # otras_redes = 'Foursquare' if params[:foursquare] == "1"
    # if params[:flickr] == "1"
    #   otras_redes << " / " if !otras_redes.blank?
    #   otras_redes << "Flickr"
    # end
    # pdf.text_box otras_redes, size: 7, at: [236, pos_y+12], width: 40
    # pdf.text_box params[:nombre_en_redes], size: 7, at: [335, pos_y+12], width: 80
    # pdf.text_box params[:direccion_pagina_web], size: 6, at: [458, pos_y+12],
    #     width: 105

    # Renglón horario de atención
    pdf.move_down 26
    pos_y = pdf.cursor
    case params[:horario_atencion]
    when "Diurno"
      pdf.draw_text 'X', size: 10, at: [54, pos_y]
    when "Nocturno"
      pdf.draw_text 'X', size: 10, at: [94, pos_y]
    when "24 horas"
      pdf.draw_text 'X', size: 10, at: [131, pos_y]
    end
    # pdf.draw_text 'X', size: 10, at: [186, pos_y+1] if params[:exento_de_retencion_en_la_fuente] == "1"
    # pdf.draw_text 'X', size: 10, at: [206, pos_y+1] if params[:exento_de_retencion_en_la_fuente] == "0"
    # pdf.draw_text 'X', size: 10, at: [261, pos_y] if params[:exento_de_retencion_de_ica] == "1"
    # pdf.draw_text 'X', size: 10, at: [281, pos_y] if params[:exento_de_retencion_de_ica] == "0"
    
    # pdf.draw_text 'X', size: 10, at: [340, pos_y] if params[:exento_de_retencion_de_iva] == "1"
    # pdf.draw_text 'X', size: 10, at: [360, pos_y] if params[:exento_de_retencion_de_iva] == "0"
    # pdf.draw_text 'X', size: 10, at: [413, pos_y] if params[:requiere_propina] == "1"
    # pdf.draw_text 'X', size: 10, at: [433, pos_y] if params[:requiere_propina] == "0"

    # Renglón tipo de establecimiento
    pdf.move_down 17
    pos_y = pdf.cursor
    case params[:tipo_de_establecimiento]
    when "Principal"
      pdf.draw_text 'X', size: 10, at: [89, pos_y]
    when "Sucursal"
      pdf.draw_text 'X', size: 10, at: [130, pos_y]
    end
    pdf.draw_text params[:porcentaje_de_retefuente], size: 8, at: [176, pos_y]
    pdf.draw_text params[:porcentaje_de_reteica], size: 8, at: [251, pos_y]
    pdf.draw_text params[:porcentaje_de_iva], size: 8, at: [330, pos_y]
    pdf.draw_text params[:porcentaje_de_impuesto_al_consumo], size: 8, at: [403, pos_y]

    pdf.draw_text 'X', size: 10, at: [433, pos_y-17]

    # Sección certificado cuenta de depósito
    pdf.move_down 42
    pos_y = pdf.cursor

    pdf.text_box "3167041513", size: 10, width: 100, at: [8, pdf.cursor-0.5], character_spacing: 3.5
    pdf.text_box "07", size: 10, width: 100, at: [181, pdf.cursor-1], character_spacing: 3.5
    pdf.draw_text "Bancolombia", size: 9, at: [286, pdf.cursor-8]
    pdf.text_box 'Central Comercializadora de Internet SAS', size: 5, at: [56, pdf.cursor-12],
        width: 73
    # pdf.draw_text 'Central Comercializadora de Internet SAS', size: 3.5, at: [56, pdf.cursor-22]
    pdf.draw_text '900293637-2', size: 9, at: [36, pdf.cursor-34]
    pdf.draw_text 'X', size: 9, at: [348, pdf.cursor-20]

    
    # pdf.text_box params[:numero_de_cuenta], size: 12,
    #     width: 110, at: [-2, pos_y+8], character_spacing: 4.7
    # pdf.text_box params[:codigo_banco], size: 12,
    #     width: 30, at: [218, pos_y+8], character_spacing: 4.7
    # pdf.draw_text params[:nombre_del_banco], size: 11, at: [284, pos_y]
    # pdf.text_box params[:codigo_sucursal_banco], size: 12,
    #     width: 30, at: [483, pos_y+8], character_spacing: 4.7
    # pdf.text_box params[:titular_cuenta], size: 7, at: [60, pos_y-7],
    #     width: 75
    # case params[:tipo_de_cuenta]
    # when "Ahorro"
    #   pdf.draw_text 'X', size: 12, at: [339, pos_y-17]
    # when "Corriente"
    #   pdf.draw_text 'X', size: 12, at: [429, pos_y-17]
    # when "Fiduciaria"
    #   pdf.draw_text 'X', size: 12, at: [524, pos_y-17]
    # end
    # pdf.draw_text params[:nit_cc], size: 11, at: [18, pos_y-34]
    # pdf.draw_text params[:nit_de_la_fiduciaria], size: 11, at: [284, pos_y-34]

    # Sección datos de los socios con participación superior a 5%
    pdf.move_down 194
    imprimir_datos_socio(pdf, params[:socios_attributes]["0"])
    pdf.move_down 25
    imprimir_datos_socio(pdf, params[:socios_attributes]["1"])


    # Sección referencias comerciales del establecimiento
    # pdf.move_down 41
    # imprimir_referencia_comercial(pdf, params[:referencias_comerciales_attributes]["0"])
    # pdf.move_down 14
    # imprimir_referencia_comercial(pdf, params[:referencias_comerciales_attributes]["1"])


    # Sección datos del representante legal
    pdf.move_down 71
    pos_y = pdf.cursor
    pdf.draw_text params[:nombres_rl], size: 9, at: [0, pos_y]
    pdf.draw_text params[:primer_apellido_rl], size: 9, at: [125, pos_y]
    pdf.draw_text params[:segundo_apellido_rl], size: 9, at: [278, pos_y]
    pdf.move_down 13
    pos_y = pdf.cursor
    case params[:tipo_documento_rl]
    when "NIT"
      pdf.draw_text 'X', size: 10, at: [54, pos_y]
    when "C.C."
      pdf.draw_text 'X', size: 10, at: [126, pos_y]
    when "C.E."
      pdf.draw_text 'X', size: 10, at: [85, pos_y-10]
    end
    pdf.text_box params[:numero_documento_rl], size: 10,
        width: 100, at: [149.5, pos_y+8.5], character_spacing: 3.5

    fecha_expedicion_documento_rl = "%02d" % params["fecha_expedicion_documento_rl(3i)"]
    fecha_expedicion_documento_rl << "%02d" % params["fecha_expedicion_documento_rl(2i)"]
    fecha_expedicion_documento_rl << params["fecha_expedicion_documento_rl(1i)"]
    pdf.text_box fecha_expedicion_documento_rl, size: 9,
        width: 80, at: [185, pos_y-2], character_spacing: 4

    fecha_de_nacimiento_rl = "%02d" % params["fecha_de_nacimiento_rl(3i)"]
    fecha_de_nacimiento_rl << "%02d" % params["fecha_de_nacimiento_rl(2i)"]
    fecha_de_nacimiento_rl << params["fecha_de_nacimiento_rl(1i)"]
    pdf.text_box fecha_de_nacimiento_rl, size: 9,
        width: 80, at: [261.5, pos_y-3.5], character_spacing: 4.7

    pdf.draw_text params[:ciudad_nacimiento_rl], size: 6, at: [363, pos_y+5]
    pdf.draw_text params[:departamento_nacimiento_rl], size: 5, at: [384, pos_y-6]
    
    pdf.move_down 23
    pos_y = pdf.cursor
    case params[:sexo_rl]
    when "Femenino"
      pdf.draw_text 'X', size: 10, at: [20, pos_y]
    when "Masculino"
      pdf.draw_text 'X', size: 10, at: [40, pos_y]
    end
    case params[:estado_civil]
    when "Soltero"
      pdf.draw_text 'X', size: 10, at: [113, pos_y]
    when "Casado"
      pdf.draw_text 'X', size: 10, at: [145, pos_y]
    when "Divorciado"
      pdf.draw_text 'X', size: 10, at: [187, pos_y]
    when "Separado"
      pdf.draw_text 'X', size: 10, at: [225, pos_y]
    when "Viudo"
      pdf.draw_text 'X', size: 10, at: [252, pos_y]
    when "Unión libre"
      pdf.draw_text 'X', size: 10, at: [292, pos_y]
    when "Religioso"
      pdf.draw_text 'X', size: 10, at: [330, pos_y]
    end
    pdf.text_box params[:correo_electronico_rl], size: 6, width: 92,
            at: [359, pos_y+9.5]

    pdf.move_down 15
    pos_y = pdf.cursor
    pdf.text_box params[:direccion_residencia_rl], size: 6, width: 120,
            at: [58, pos_y+10.5]
    # pdf.draw_text params[:direccion_residencia_rl], size: 6, at: [58, pos_y+6]
    pdf.text_box params[:ciudad_residencia_rl], size: 6, width: 61,
      at: [196, pos_y+10.5]
    pdf.draw_text params[:telefono_rl], size: 6, at: [257, pos_y]
    pdf.draw_text params[:celular_rl], size: 6, at: [353, pos_y]

    pdf.move_down 14
    pos_y = pdf.cursor
    pdf.text_box params[:profesion_ocupacion_rl], size: 6, width: 52,
            at: [28, pos_y+10.5]
    # pdf.draw_text params[:profesion_ocupacion_rl], size: 5.5, at: [0, pos_y]

    case params[:tipo_profesion_rl]
    when "Independiente"
      pdf.draw_text 'X', size: 9, at: [120, pos_y+3]
    when "Empleado"
      pdf.draw_text 'X', size: 9, at: [158, pos_y+3]
    when "Servidor público"
      pdf.draw_text 'X', size: 9, at: [216, pos_y+3]
    when "Socios"
      pdf.draw_text 'X', size: 9, at: [246, pos_y+3]
    when "Estudiante"
      pdf.draw_text 'X', size: 9, at: [286, pos_y+3]
    when "Ama de casa"
      pdf.draw_text 'X', size: 9, at: [328, pos_y+3]
    when "Pensionado"
      pdf.draw_text 'X', size: 9, at: [370, pos_y+3]
    end

    pdf.text_box params[:cargo_rl], size: 6, width: 55,
            at: [398.5, pos_y+10.5]
    # pdf.draw_text params[:cargo_rl], size: 6, at: [396, pos_y]
    pdf.move_down 14
    pos_y = pdf.cursor
    pdf.draw_text 'X', size: 9, at: [103, pos_y] if params[:administra_recursos_publicos_rl] == "1"
    pdf.draw_text 'X', size: 9, at: [128, pos_y] if params[:administra_recursos_publicos_rl] == "0"
    pdf.draw_text 'X', size: 9, at: [271, pos_y] if params[:ostenta_algun_grado_de_poder_publico_rl] == "1"
    pdf.draw_text 'X', size: 9, at: [294, pos_y] if params[:ostenta_algun_grado_de_poder_publico_rl] == "0"
    pdf.draw_text 'X', size: 9, at: [418, pos_y] if params[:goza_de_reconocimiento_publico_rl] == "1"
    pdf.draw_text 'X', size: 9, at: [439, pos_y] if params[:goza_de_reconocimiento_publico_rl] == "0"

    # Sección referencias personales del representante legal
    # pdf.move_down 44
    # imprimir_referencia_personal(pdf, params[:referencias_personales_attributes]["0"])
    # pdf.move_down 15
    # imprimir_referencia_personal(pdf, params[:referencias_personales_attributes]["1"])





    # Segunda página
    pdf.start_new_page

    # Sección información económica del establecimiento
    pdf.move_down 0
    pos_y = pdf.cursor


    pdf.draw_text "5.000.000", size: 9, at: [9, pos_y+3]
    pdf.draw_text "5.000.000", size: 9, at: [120, pos_y+3]
    pdf.draw_text "3.000.000", size: 9, at: [230, pos_y+3]
    pdf.draw_text "10.000.000", size: 9, at: [320, pos_y+3]
    pdf.draw_text "3.000.000", size: 9, at: [390, pos_y+3]
    pdf.draw_text 'X', size: 9, at: [72, pos_y-20]

    pdf.move_down 234
    pos_y = pdf.cursor

    pdf.draw_text 'X', size: 9, at: [36, pos_y]
    pdf.draw_text 'X', size: 9, at: [136, pos_y-20]
    pdf.draw_text 'X', size: 9, at: [210, pos_y-25]


    pdf.move_down 255
    pos_y = pdf.cursor

    if params[:numero_documento_rl]   
        pdf.draw_text params[:numero_documento_rl], size: 7, at: [42, pos_y]
    else
        pdf.draw_text params[:numero_documento_comercio], size: 7, at: [42, pos_y]
    end



    # USO EXCLUSIVO DE REDEBAN
    # pdf.move_down 280
    # pos_y = pdf.cursor
    # pdf.draw_text 'X', size: 9, at: [218, pos_y-5]
    # pdf.draw_text 'X', size: 9, at: [380, pos_y-43]

    # pdf.move_down 106
    # pos_y = pdf.cursor
    # pdf.draw_text 'X', size: 9, at: [118, pos_y]
    # pdf.draw_text 'X', size: 9, at: [252, pos_y-2]

    # pdf.draw_text params[:ingresos_operacionales], size: 11, at: [-5, pos_y]
    # pdf.draw_text params[:ingresos_mensuales], size: 11, at: [137, pos_y]
    # pdf.draw_text params[:egresos_mensuales], size: 11, at: [271, pos_y]
    # pdf.draw_text params[:total_activos], size: 11, at: [393, pos_y]
    # pdf.draw_text params[:total_pasivos], size: 11, at: [484, pos_y]
    # case params[:operaciones_internacionales]
    # when "Sí"
    #   pdf.draw_text 'X', size: 12, at: [78, pos_y-18]
    # when "No"
    #   pdf.draw_text 'X', size: 12, at: [78, pos_y-31.5]
    # # end
    # pdf.draw_text 'X', size: 12, at: [343, pos_y-18] if params[:importacion_oi] == "1"
    # pdf.draw_text 'X', size: 12, at: [484, pos_y-18] if params[:prestamos_oi] == "1"
    # pdf.draw_text 'X', size: 12, at: [343, pos_y-31.5] if params[:exportacion_oi] == "1"
    # pdf.draw_text 'X', size: 12, at: [425, pos_y-18] if params[:pago_de_servicios_oi] == "1"
    # pdf.draw_text 'X', size: 12, at: [549, pos_y-18] if params[:inversiones_oi] == "1"

    pdf
  end

  private

    def self.imprimir_datos_socio(pdf, params)
      pos_y = pdf.cursor
      pdf.draw_text params[:nombres_y_apellidos], size: 7, at: [-2, pos_y]
      pdf.text_box params[:porcentaje_participacion], size: 9,
          width: 30, at: [116, pos_y+8.5], character_spacing: 3.5, align: :right
      case params[:tipo_documento]
      # when "NIT"
      #   pdf.draw_text 'NIT', size: 8, at: [127, pos_y]
      when "C.C."
        pdf.draw_text 'X', size: 9, at: [160, pos_y]
      when "C.E."
        pdf.draw_text 'X', size: 9, at: [175, pos_y]
      end
      pdf.draw_text params[:numero_documento], size: 6.5, at: [233, pos_y+12]
      pdf.text_box params[:ciudad], size: 6, width: 85,
            at: [303, pos_y+16]
      pdf.draw_text params[:telefono], size: 6.5, at: [388, pos_y+11]
      pdf.draw_text params[:celular], size: 6.5, at: [235, pos_y]
      pdf.text_box params[:direccion], size: 4.8, width: 90,
            at: [361, pos_y+7.6]
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
