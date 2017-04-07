class FormAmex
  include Utilitario

  def self.generar(params)
    pdf = Prawn::Document.new(left_margin: 29,
                        top_margin:29,
                        page_size: "LETTER")
    pdf.move_down 147
    pdf.draw_text 'CCI*' + params[:razon_social], size: 9, at: [0, pdf.cursor]
    pdf.draw_text params[:nombre_comercial], size: 8, at: [253, pdf.cursor]
    case params[:tipo_documento_comercio]
    when "NIT"
      pdf.draw_text 'X', size: 8, at: [488, pdf.cursor+12]
    when "C.C."
      pdf.draw_text 'X', size: 10, at: [488, pdf.cursor]
    when "C.E."
      pdf.draw_text 'X', size: 10, at: [508, pdf.cursor+12]
    end

    pdf.move_down 16
    pdf.text_box (params[:numero_documento_comercio]), size: 10,
        width: 120, at: [2, pdf.cursor], character_spacing: 5.2
    pdf.draw_text params[:digito_de_verificacion], size: 10, at: [142, pdf.cursor-7]
    pdf.text_box params[:numero_de_matricula_mercantil], size: 10, width: 60,
          at: [175, pdf.cursor], character_spacing: 5.2
    cadena = preprocesar(params[:responsabilidad_tributaria])
    pdf.text_box cadena, size: 10, width: 210,
            at: [363, pdf.cursor], character_spacing: 5.2

    pdf.move_down 22
    pos_y = pdf.cursor
    case params[:naturaleza]
    when "Jurídica"
      pdf.draw_text 'X', size: 8, at: [154, pos_y]
    when "Natural"
      pdf.draw_text 'X', size: 8, at: [220, pos_y]
    end
    case params[:tipo_de_empresa]
      when "Mixta"
      pdf.draw_text 'X', size: 8, at: [504, pos_y-2]
    when "Pública"
      pdf.draw_text 'X', size: 8, at: [376, pos_y-1]
    else #Privada
      pdf.draw_text 'X', size: 8, at: [438, pos_y-1]
    end

    # Sección Dirección del establecimiento
    pdf.move_down 18
    pos_y = pdf.cursor
    pdf.text_box params[:direccion_del_establecimiento], size: 7, at: [0, pos_y],
        width: 280
    pdf.draw_text params[:departamento_establecimiento], size: 8, at: [283, pos_y-10]
    pdf.text_box params[:codigo_ciudad], size: 10, width: 30,
            at: [451, pos_y-5], character_spacing: 5.2

    pdf.move_down 35
    pos_y = pdf.cursor
    pdf.draw_text params[:telefono_del_establecimiento], size: 10, at: [142, pos_y]
    pdf.text_box params[:direccion_pagina_web], size: 9, at: [283, pos_y+8],
        width: 160

      # Sección datos del representante legal
      pdf.move_down 33
      pos_y = pdf.cursor
      pdf.draw_text nombres_y_apellidos_rl(params), size: 8, at: [13, pos_y]
      case params[:tipo_documento_rl]
      when "NIT"
        pdf.draw_text 'X', size: 7, at: [304, pos_y+12]
      when "C.C."
        pdf.draw_text 'X', size: 7, at: [304, pos_y]
      when "C.E."
        pdf.draw_text 'X', size: 7, at: [340, pos_y+11]
      end
      pdf.draw_text ("%02d" % params["fecha_expedicion_documento_rl(3i)"]), size: 12, at: [448, pos_y+2]
      pdf.draw_text ("%02d" % params["fecha_expedicion_documento_rl(2i)"]), size: 12, at: [482, pos_y+2]
      pdf.draw_text params["fecha_expedicion_documento_rl(1i)"], size: 12, at: [516, pos_y+2]
      pdf.move_down 15
      pos_y = pdf.cursor
      pdf.text_box params[:numero_documento_rl], size: 12, width: 80,
              at: [21, pos_y], character_spacing: 8.5
      pdf.text_box params[:direccion_residencia_rl], size: 8, width: 110,
              at: [250, pos_y+11]
      pdf.text_box params[:ciudad_residencia_rl], size: 8, width: 100,
              at: [356, pos_y+4]
      pdf.draw_text params[:telefono_rl], size: 10, at: [458, pos_y-8]

      # Sección Dirección de correspondencia/notificaciones
      pdf.move_down 40
      pos_y = pdf.cursor
      pdf.draw_text params[:direccion_correspondencia], size: 7, at: [0, pos_y]
      pdf.draw_text params[:departamento_correspondencia], size: 8, at: [271, pos_y]
      pdf.draw_text params[:ciudad_correspondencia], size: 8, at: [422, pos_y]
      pdf.move_down 21
      pos_y = pdf.cursor
      pdf.draw_text params[:telefono_correspondencia], size: 10, at: [1, pos_y]
      pdf.draw_text params[:correo_electronico], size: 8, at: [153, pos_y]
      case params[:horario_atencion]
      when "Diurno"
        pdf.draw_text "X", size: 7, at: [463, pos_y+12], style: :bold_italic
      when "Nocturno"
        pdf.draw_text 'X', size: 7, at: [503, pos_y+12], style: :bold_italic
      when "24 horas"
        pdf.draw_text 'X', size: 7, at: [503, pos_y+1], style: :bold_italic
      end
      # Afiliación a otros sistemas
      pdf.move_down 22
      pos_y = pdf.cursor
      pdf.draw_text 'X', size: 7, at: [95, pos_y+1], style: :bold_italic
      # Tipo de afiliación: permanente - Tipo de Venta: presencial
      pdf.move_down 10
      pos_y = pdf.cursor
      pdf.draw_text 'X', size: 7, at: [95, pos_y], style: :bold_italic
      pdf.draw_text 'X', size: 7, at: [464, pos_y-1], style: :bold_italic
      # Medio de Venta - datáfono
      pdf.move_down 22
      pos_y = pdf.cursor
      pdf.draw_text 'X', size: 7, at: [157, pos_y], style: :bold_italic

      # Sección información financiera
      pdf.move_down 71
      pos_y = pdf.cursor
      pdf.draw_text '5.000.000', size: 12, at: [105, pos_y]  # Ingresos mensuales
      pdf.draw_text '3.000.000', size: 12, at: [371, pos_y]  # Egresos mensuales
      pdf.draw_text '10.000.000', size: 12, at: [105, pos_y-20]  # Total activos
      pdf.draw_text '4.000.000', size: 12, at: [371, pos_y-20]  # Total pasivos

      # Sección cuenta bancaria para abonos
      pdf.move_down 46
      pos_y = pdf.cursor
      # Código de la entidad
      pdf.text_box '07', size: 11, width: 20,
              at: [84, pos_y], character_spacing: 5.2
      pdf.draw_text 'Bancolombia', size: 10, at: [152, pos_y-9]
      pdf.draw_text 'Central Comercializadora de Internet S.A.S', size: 10, at: [299, pos_y-9]
      pdf.move_down 23
      pos_y = pdf.cursor
      pdf.text_box '900293637-2', size: 11, width: 140,
              at: [82, pos_y], character_spacing: 5.2
      pdf.draw_text 'X', size: 7, at: [290, pos_y+3], style: :bold_italic
      # Tipo cuenta: Cte
      pdf.draw_text 'X', size: 7, at: [469, pos_y+5], style: :bold_italic
      pdf.move_down 22
      pos_y = pdf.cursor
      # Número cuenta
      pdf.text_box '3167041513', size: 12, width: 140,
              at: [135, pos_y], character_spacing: 10.6

      # Segunda página
      pdf.start_new_page



      # Sección cuenta bancaria para abonos
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

      # Sección información financiera
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
      # #numero = NumeroString.new(params[:monto_estimado_mensual_oi])
      # pdf.draw_text params[:monto_estimado_mensual_oi], size: 9, at: [15, pos_y-104]
      # pdf.draw_text 'X', size: 9, at: [241, pos_y-56] if params[:importacion_oi] == "1"
      # pdf.draw_text 'X', size: 9, at: [241, pos_y-68] if params[:prestamos_oi] == "1"
      # pdf.draw_text 'X', size: 9, at: [241, pos_y-80] if params[:exportacion_oi] == "1"
      # pdf.draw_text 'X', size: 9, at: [241, pos_y-93] if params[:pago_de_servicios_oi] == "1"
      # pdf.draw_text 'X', size: 9, at: [241, pos_y-106] if params[:inversiones_oi] == "1"

      # Sección datos del representante legal
      # pdf.draw_text params[:ciudad_expedicion_documento_rl], size: 9, at: [415, pos_y-49]
      # pdf.draw_text ("%02d" % params["fecha_de_nacimiento_rl(3i)"]), size: 9, at: [10, pos_y-76]
      # pdf.draw_text ("%02d" % params["fecha_de_nacimiento_rl(2i)"]), size: 9, at: [25, pos_y-76]
      # pdf.draw_text params["fecha_de_nacimiento_rl(1i)"], size: 9, at: [40, pos_y-76]
      # pdf.draw_text params[:ciudad_nacimiento_rl], size: 8, at: [190, pos_y-63]
      # pdf.draw_text params[:departamento_nacimiento_rl], size: 7, at: [213, pos_y-76]
      # case params[:sexo_rl]
      # when "Femenino"
      #   pdf.draw_text 'X', size: 8, at: [409, pos_y-77]
      # when "Masculino"
      #   pdf.draw_text 'X', size: 8, at: [467, pos_y-77]
      # end
      # pdf.draw_text params[:correo_electronico_rl], size: 7, at: [4, pos_y-124]
      # pdf.draw_text params[:profesion_ocupacion_rl], size: 8, at: [210, pos_y-124]
      # pdf.draw_text params[:cargo_rl], size: 8, at: [421, pos_y-124]



    # pdf.draw_text params[:celular], size: 10, at: [285, pos_y]
    # pdf.draw_text params[:fax], size: 10, at: [395, pos_y]
    # pdf.text_box params[:codigo_departamento], size: 9, width: 30,
    #         at: [509, pos_y+9], character_spacing: 4.8

    # Sección venta de tiquetes
    # pdf.move_down 32
    # pos_y = pdf.cursor
    # case params[:agencia_de_viajes]
    # when "Agencia de viajes"
    #   pdf.draw_text 'X', size: 10, at: [65, pos_y]
    # when "Venta propia"
    #   pdf.draw_text 'X', size: 10, at: [127, pos_y]
    # when "Venta propia y de tiquetes"
    #   pdf.draw_text 'X', size: 10, at: [231, pos_y]
    # when "Aerolínea"
    #   pdf.draw_text 'X', size: 10, at: [400, pos_y]
    # end
    # unless params[:numero_iata_av].blank?
    #   pdf.text_box params[:numero_iata_av], size: 10, width: 50,
    #         at: [276, pos_y+8], character_spacing: 4
    # end
    #
    # case params[:requiere_impuestos_av]
    # when "Sí"
    #   pdf.draw_text 'X', size: 10, at: [499, pos_y]
    # when "No"
    #   pdf.draw_text 'X', size: 10, at: [527, pos_y]
    # end

    # Sección actividad comercial y responsabilidad tributaria
    # pdf.move_down 13
    # pos_y = pdf.cursor
    # pdf.draw_text params[:actividad_comercial], size: 10, at: [71, pos_y]
    # pdf.text_box params[:codigo_ciiu], size: 9, width: 30,
    #         at: [416, pos_y+8-27], character_spacing: 4.8
    # pdf.text_box params[:mcc], size: 9, width: 30,
    #         at: [416, pos_y+8-39], character_spacing: 4.8
    #
    # # Sección Tipo de afiliación
    # pdf.move_down 70
    # pos_y = pdf.cursor
    # pdf.draw_text 'X', size: 10, at: [86, pos_y] if params[:venta_presencial_ta] == "1"
    # pdf.draw_text 'X', size: 10, at: [149, pos_y] if params[:mi_pago_ta] == "1"
    # pdf.draw_text 'X', size: 10, at: [60, pos_y-25] if params[:multicomercio_ta] == "1"
    # case params[:comercio_principal_secundario_ta]
    # when "Principal"
    #   pdf.draw_text 'X', size: 10, at: [149, pos_y-25]
    # when "Secundario"
    #   pdf.draw_text 'X', size: 10, at: [245, pos_y-25]
    # end
    #
    # # Sección Venta No Presencial
    # pdf.move_down 40
    # pos_y = pdf.cursor
    # pdf.draw_text 'X', size: 10, at: [78, pos_y] if params[:venta_no_presencial] == "1"
    # pdf.draw_text 'X', size: 10, at: [78, pos_y-12] if params[:paga_cuentas] == "1"
    # pdf.draw_text 'X', size: 10, at: [234, pos_y-12] if params[:visa_distribucion] == "1"
    # pdf.draw_text 'X', size: 10, at: [294, pos_y-12] if params[:pse] == "1"
    # pdf.draw_text 'X', size: 10, at: [78, pos_y-24] if params[:web_de_pagos] == "1"
    # pdf.draw_text 'X', size: 10, at: [150, pos_y-24] if params[:recurrente] == "1"
    # pdf.draw_text 'X', size: 10, at: [180, pos_y-24] if params[:api] == "1"
    # pdf.draw_text 'X', size: 10, at: [256, pos_y-24] if params[:boton_de_pagos] == "1"
    # pdf.draw_text 'X', size: 10, at: [324, pos_y-24] if params[:mall_virtual] == "1"
    # pdf.draw_text 'X', size: 10, at: [527, pos_y-12] if params[:modulo_basico_afs] == "1"
    # pdf.draw_text 'X', size: 10, at: [527, pos_y-24] if params[:modulo_avanzado_cybersource] == "1"
    #
    #
    # # Sección presencia en Internet
    # pdf.draw_text 'X', size: 9, at: [463, pos_y-13] if params[:facebook] == "1"
    # pdf.draw_text 'X', size: 9, at: [510, pos_y-13] if params[:twitter] == "1"
    # pdf.draw_text 'X', size: 9, at: [557.5, pos_y-13] if params[:youtube] == "1"
    # pdf.draw_text 'X', size: 9, at: [351, pos_y-27] if params[:foursquare] == "1"
    # pdf.draw_text 'X', size: 9, at: [391, pos_y-27] if params[:flickr] == "1"
    # pdf.draw_text 'Linkedin', size: 9, at: [454, pos_y-24] if params[:linkedin] == "1"
    #
    # # Sección tipo de establecimiento
    # pdf.move_down 60
    # pos_y = pdf.cursor
    # case params[:tipo_de_establecimiento]
    # when "Principal"
    #   pdf.draw_text 'X', size: 9, at: [127, pos_y]
    # when "Sucursal"
    #   pdf.draw_text 'X', size: 9, at: [178, pos_y]
    # end
    # pdf.draw_text 'X', size: 9, at: [287, pos_y] if params[:afiliado_a_otro_sistema] == "1"
    # pdf.draw_text 'X', size: 9, at: [314, pos_y] if params[:afiliado_a_otro_sistema] == "0"
    # pdf.text_box params[:codigo_unico], size: 9, width: 50,
    #         at: [382, pos_y+6], character_spacing: 4.5
    # pdf.draw_text 'X', size: 9, at: [99, pos_y-15] if params[:posee_medio_de_acceso] == "1"
    # pdf.draw_text 'X', size: 9, at: [127, pos_y-15] if params[:posee_medio_de_acceso] == "0"
    # case params[:tipo_medio_acceso]
    # when "Dial/Lan"
    #   pdf.draw_text 'X', size: 9, at: [178, pos_y-15]
    # when "GPRS"
    #   pdf.draw_text 'X', size: 9, at: [219, pos_y-15]
    # when "MPOS"
    #   pdf.draw_text 'X', size: 9, at: [266, pos_y-15]
    # end
    # case params[:propietario_medio_acceso]
    # when "Credibanco"
    #   pdf.draw_text 'X', size: 9, at: [497, pos_y-15]
    # when "Otra red"
    #   pdf.draw_text 'X', size: 9, at: [546, pos_y-15]
    # end
    #
    # # Sección exenciones tributarias
    # pdf.move_down 32
    # pos_y = pdf.cursor
    # pdf.draw_text 'X', size: 9, at: [97, pos_y] if params[:exento_de_retencion_de_iva] == "1"
    # pdf.draw_text 'X', size: 9, at: [173, pos_y] if params[:exento_de_retencion_de_ica] == "1"
    # pdf.draw_text 'X', size: 9, at: [269, pos_y] if params[:exento_de_retencion_en_la_fuente] == "1"
    # pdf.draw_text 'X', size: 9, at: [359, pos_y] if params[:requiere_propina] == "1"
    # pdf.draw_text 'X', size: 9, at: [390, pos_y] if params[:requiere_propina] == "0"
    #
    # # Sección porcentajes de impuestos
    # pdf.move_down 15
    # pos_y = pdf.cursor
    # pdf.draw_text params[:porcentaje_de_iva], size: 9, at: [55, pos_y]
    # pdf.draw_text params[:porcentaje_de_reteica], size: 9, at: [145, pos_y]
    # pdf.draw_text params[:porcentaje_de_retefuente], size: 9, at: [241, pos_y]
    # pdf.draw_text params[:porcentaje_de_impuesto_al_consumo], size: 9, at: [377, pos_y]
    #
    # # Sección datos de los socios con participación superior a 5%
    # pdf.move_down 166
    # imprimir_datos_socio(pdf, params[:socios_attributes]["0"])
    # pdf.move_down 15
    # imprimir_datos_socio(pdf, params[:socios_attributes]["1"])
    # pdf.move_down 15
    # imprimir_datos_socio(pdf, params[:socios_attributes]["2"])
    #
    # # Sección referencias personales del propietario
    # pdf.move_down 51
    # imprimir_referencia(pdf, params[:referencias_personales_attributes]["0"])
    # pdf.move_down 12
    # imprimir_referencia(pdf, params[:referencias_personales_attributes]["1"])
    #
    # # Sección referencias comerciales del establecimiento
    # pdf.move_down 34
    # imprimir_referencia(pdf, params[:referencias_comerciales_attributes]["0"])
    # pdf.move_down 12
    # imprimir_referencia(pdf, params[:referencias_comerciales_attributes]["1"])
    #

    #Firma del representante legal
    pdf.move_down 653
    pos_y = pdf.cursor
    pdf.draw_text params[:razon_social], size: 9, at: [1, pos_y]
    pdf.draw_text nombres_y_apellidos_rl(params), size: 8, at: [1, pos_y-40]
    pdf.draw_text documento_firma(pdf, params), size: 8, at: [1, pos_y-80]

    pdf
  end

  private

    def self.documento_firma(pdf, params)
      if nombres_y_apellidos_rl(params).blank? && params[:tipo_documento_comercio] == 'C.C.'
        return params[:numero_documento_comercio]
      else
        return params[:numero_documento_rl]
      end
    end

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

    def self.nombres_y_apellidos_rl(params)
      temp = params[:nombres_rl] + " " + params[:primer_apellido_rl]
      temp << " " + params[:segundo_apellido_rl]
      return temp
    end

end
