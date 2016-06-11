module Utilitario
  extend ActiveSupport::Concern
  
  private
  
    included do
      def self.preprocesar(codigos_responsabilidad_tributaria)
        # Primero eliminar los separadores que pueden ser: espacio, guión o coma.
        arreglo = codigos_responsabilidad_tributaria.split((%r{,|-|\s+}))
        # Se retorna un string concatenando las subcadenas del arreglo
        arreglo.join
      end
    end
end
