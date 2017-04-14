class Client < ActiveRecord::Base

  def self.generate(params)
    client_params = {name: params[:nombres_rl] + " " + params[:primer_apellido_rl] + " " + params[:segundo_apellido_rl],
                     email: params[:correo_electronico_rl],
                     telephone: params[:telefono_rl],
                     celphone: params[:celular_rl],
                     business_name: params[:razon_social],
                     commerce_name: params[:nombre_comercial]
                    }
    client = Client.create(client_params)
  end

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      # csv << column_names
      csv << ['ID', 'Nombre', 'Email', 'Telefono', 'Celular', 'Negocio', 'Comercio', "Fecha de Ingreso"]
      all.each do |client|
        # csv << client.attributes.values_at(*column_names)
        csv << [client.id, client.name, client.email, client.telephone, client.celphone, client.business_name, client.commerce_name, client.created_at]
      end
    end
  end
end
