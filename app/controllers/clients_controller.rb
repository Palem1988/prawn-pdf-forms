class ClientsController < ApplicationController

  def index
    @clients = Client.order(:name)
    respond_to do |format|
      format.html
      format.csv { send_data @clients.to_csv }
      format.xls { send_data @clients.to_csv(col_sep: "\t") }
    end
  end

  def destroy
    Client.all.each do |client|
      client.destroy
    end
    redirect_to root_path
  end
end
