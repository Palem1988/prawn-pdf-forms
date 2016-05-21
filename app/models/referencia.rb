class Referencia
  include ActiveModel::Model
  
  attr_accessor :celular,
        :ciudad,
        :correo_electronico,
        :direccion,
        :nombres_y_apellidos,
        :telefono
end