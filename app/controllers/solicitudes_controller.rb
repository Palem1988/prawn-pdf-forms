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
                                        :agencia_de_viajes,
                                        :api,
                                        :boton_de_pagos,
                                        :codigo_ciiu,
                                        :comercio_principal_secundario_ta,
                                        :mall_virtual,
                                        :mcc,
                                        :mi_pago_ta,
                                        :multicomercio_ta,
                                        :naturaleza,
                                        :numero_iata_av,
                                        :numero_de_matricula_mercantil,
                                        :numero_documento_comercio,
                                        :paga_cuentas,
                                        :pse,
                                        :razon_social,
                                        :recurrente,
                                        :requiere_impuestos_av,
                                        :responsabilidad_tributaria,
                                        :tiene_matricula_mercantil,
                                        :tipo_de_afiliacion,
                                        :tipo_de_empresa,
                                        :tipo_documento_comercio,
                                        :venta_no_presencial,
                                        :venta_presencial_ta,
                                        :visa_distribucion,
                                        :web_de_pagos)
    end

end
