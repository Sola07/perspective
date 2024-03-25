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
  end

  def info_sci
  end

  def info_lmnp
  end

end
