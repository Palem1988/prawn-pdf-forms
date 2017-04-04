class CitiesController < ApplicationController
  def new
    @city = City.new
  end

  def import
    City.import(params[:file])
    redirect_to root_url, notice: "Ciudades importadas"
  end
end
