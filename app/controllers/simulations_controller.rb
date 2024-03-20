class SimulationsController < ApplicationController

  def new
    @simulation = Simulation.new
  end

  def create
    @simulation = Simulation.new(simulation_params)
    @simulation.user = current_user
    @simulation.save
    # if @simulation.save
    #   redirect_to edit_first_step_path(@simulation)
    # else
    #   render :new, status: :unprocessable_entity
  end

  private

  def simulation_params
    params.require(:simulation).permit(:prix_du_bien, :prix_travaux_renov, :prix_travaux_cont, :achat_meubles)
  end

end
