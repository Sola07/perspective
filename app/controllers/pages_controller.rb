class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home, :profile]

  def home
  end

  def profile
    @simulations = Simulation.where(user: current_user)
    if params[:id].present?
      @simulation = Simulation.find(params[:id])
    else
      @simulation = @simulations.last
    end
    @cout_imp_sci_is = @simulation.cout_imp_sci_is
    @cash_mens_ap_imp_sci_is = @simulation.cash_mens_ap_imp_sci_is
    @char_deduct_sci_is = @simulation.char_deduct_sci_is
    @rent_net_sci_is = @simulation.rent_net_sci_is
  end

  def info_sci
  end

  def info_lmnp
  end

end
