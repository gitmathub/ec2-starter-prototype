class InstancesController < ApplicationController

  def index
   @instances = Instance.all
  end

  def show
    @instance = Instance.find(params[:id])
  end

  def new
    @instance = Instance.new
  end

  def edit
    @instance =Instance.find(params[:id])
  end

  def create
    @instance = Instance.new(instance_params)

    if @instance.save
      redirect_to @instance
    else
      render 'new'
    end
  end

  def update
    @instance = Instance.find(params[:id])
 
    if @instance.update(instance_params)
      redirect_to @instance
    else
      render 'edit'
    end
  end

  def destroy
    @instance = Instance.find(params[:id])
    @instance.destroy
 
    redirect_to instances_path
  end

  private
    def instance_params
      params.require(:instance).permit(:image_id, :instance_type, :region, :access_key_id, :secret_access_key, :linux_user, :linux_password)
    end


end
