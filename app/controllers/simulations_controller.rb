class SimulationsController < ApplicationController

  def new
    if params[:id]
      @simulation = Simulation.find(params[:id])
    else
      @simulation = Simulation.new
    end
  end

  def create
    @simulation = Simulation.new(simulation_params)
    @simulation.user = current_user
    @simulation.save
    if @simulation.save
      redirect_to edit_first_step_simulation_path(@simulation)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update_name
    @simulation = Simulation.find(params[:id])
    @simulation.update(name: params[:simulation][:name])
    if @simulation.save
      redirect_to profile_path(@simulation)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @simulation = Simulation.find(params[:id])
    @simulation.save
    if @simulation.save
      redirect_to edit_first_step_simulation_path(@simulation)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit_first_step
    @simulation = Simulation.find(params[:id])
  end

  def update_first_step
    @simulation = Simulation.find(params[:id])
    @simulation.update(simulation_params)

    if @simulation.save
      redirect_to edit_second_step_simulation_path(@simulation)
    else
      render :edit_first_step, status: :unprocessable_entity
    end
  end

  def edit_second_step
    @simulation = Simulation.find(params[:id])
  end

  def update_second_step
    @simulation = Simulation.find(params[:id])
    @simulation.update(simulation_params)
    if @simulation.save
      redirect_to edit_third_step_simulation_path(@simulation)
    else
      render :edit_second_step, status: :unprocessable_entity
    end
  end

  def edit_third_step
    @simulation = Simulation.find(params[:id])
  end

  def update_third_step
    @simulation = Simulation.find(params[:id])
    @simulation.update(simulation_params)
    if @simulation.save
      redirect_to edit_last_step_simulation_path(@simulation)
    else
      render :edit_third_step, status: :unprocessable_entity
    end
  end

  def edit_last_step
    @simulation = Simulation.find(params[:id])
  end

  def update_last_step
    @simulation = Simulation.find(params[:id])
    @simulation.update(simulation_params)
    if @simulation.save
      redirect_to simulation_path(@simulation)
    else
      render :edit_last_step, status: :unprocessable_entity
    end
  end

  def show
    @simulation = Simulation.find(params[:id])
    # @simulation = Simulation.new
  end

  def destroy
    @simulation = Simulation.find(params[:id])
    @simulation.destroy
    redirect_to profile_path, status: :see_other
  end

  private

  def simulation_params
    params.require(:simulation).permit(:prix_du_bien, :prix_travaux_renov, :prix_travaux_cont, :achat_meubles, :frais_achat,
                                       :apport, :duree_credit_an, :taux_interet, :taux_assurance,
                                       :loyer_hc, :charges_locatives,
                                       :autres_charges, :taxe_fonciere,
                                       :revenu_net_global,
                                       :name
                                      )
  end
end
