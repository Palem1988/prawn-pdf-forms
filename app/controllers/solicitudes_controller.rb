class SolicitudesController < ApplicationController
  
  def create
    pdf_credibanco = FormularioCredibanco.generar(params_solicitud)
    pdf_redeban = Prawn::Document.new(left_margin: 50, page_size: [637.92, 1006.56])
    pdf_combinado = CombinePDF.new
    pdf_combinado << CombinePDF.load("solicitud-afiliacion-establecimientos-comercio.pdf")
    pdf_combinado << CombinePDF.parse(pdf_credibanco.render)
    pdf_combinado << CombinePDF.load("Formulario+de+afiliacion+RBM_agosto+2015.pdf")
    pdf_combinado << CombinePDF.parse(pdf_redeban.render)
    pdf_combinado.pages[0] << CombinePDF.parse(pdf_credibanco.render).pages[0]
    send_data pdf_combinado.to_pdf, filename: "solicitudes.pdf", type: "application/pdf"
  end
  
  def new
    @solicitud = Solicitud.new
  end
  
  private
  
    def params_solicitud
      params.require(:solicitud).permit(:actividad_comercial,
                                        :afiliado_a_otro_sistema,
                                        :agencia_de_viajes,
                                        :api,
                                        :boton_de_pagos,
                                        :celular,
                                        :ciudad_correspondencia,
                                        :codigo_banco,
                                        :codigo_ciiu,
                                        :codigo_ciudad,
                                        :codigo_departamento,
                                        :codigo_sucursal_banco,
                                        :codigo_unico,
                                        :comercio_principal_secundario_ta,
                                        :correo_electronico,
                                        :direccion_correspondencia,
                                        :direccion_del_establecimiento,
                                        :direccion_pagina_web,
                                        :exento_de_retencion_de_ica,
                                        :exento_de_retencion_de_iva,
                                        :exento_de_retencion_en_la_fuente,
                                        :facebook,
                                        :fax,
                                        :flickr,
                                        :foursquare,
                                        :horario_atencion,
                                        :linkedin,
                                        :mall_virtual,
                                        :mcc,
                                        :mi_pago_ta,
                                        :modulo_avanzado_cybersource,
                                        :modulo_basico_afs,
                                        :multicomercio_ta,
                                        :naturaleza,
                                        :nit_cc,
                                        :nit_de_la_fiduciaria,
                                        :nombre_del_banco,
                                        :numero_de_cuenta,
                                        :numero_de_matricula_mercantil,
                                        :numero_documento_comercio,
                                        :numero_iata_av,
                                        :paga_cuentas,
                                        :porcentaje_de_impuesto_al_consumo,
                                        :porcentaje_de_iva,
                                        :porcentaje_de_retefuente,
                                        :porcentaje_de_reteica,
                                        :posee_medio_de_acceso,
                                        :propietario_medio_acceso,
                                        :pse,
                                        :razon_social,
                                        :recurrente,
                                        :requiere_impuestos_av,
                                        :requiere_propina,
                                        :responsabilidad_tributaria,
                                        :telefono_correspondencia,
                                        :telefono_del_establecimiento,
                                        :tiene_matricula_mercantil,
                                        :tipo_de_afiliacion,
                                        :tipo_de_cuenta,
                                        :tipo_de_empresa,
                                        :tipo_de_establecimiento,
                                        :tipo_documento_comercio,
                                        :tipo_medio_acceso,
                                        :titular_cuenta,
                                        :twitter,
                                        :venta_no_presencial,
                                        :venta_presencial_ta,
                                        :visa_distribucion,
                                        :web_de_pagos,
                                        :youtube)
    end

end
