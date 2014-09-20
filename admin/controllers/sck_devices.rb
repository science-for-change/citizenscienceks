Citizenscienceks::Admin.controllers :sck_devices do
  get :index do
    @title = "Sck_devices"
    @sck_devices = SckDevice.all
    render 'sck_devices/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'sck_device')
    @sck_device = SckDevice.new
    render 'sck_devices/new'
  end

  post :create do
    @sck_device = SckDevice.new(params[:sck_device])
    if @sck_device.save
      @title = pat(:create_title, :model => "sck_device #{@sck_device.id}")
      flash[:success] = pat(:create_success, :model => 'SckDevice')
      params[:save_and_continue] ? redirect(url(:sck_devices, :index)) : redirect(url(:sck_devices, :edit, :id => @sck_device.id))
    else
      @title = pat(:create_title, :model => 'sck_device')
      flash.now[:error] = pat(:create_error, :model => 'sck_device')
      render 'sck_devices/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "sck_device #{params[:id]}")
    @sck_device = SckDevice.find(params[:id])
    if @sck_device
      render 'sck_devices/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'sck_device', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "sck_device #{params[:id]}")
    @sck_device = SckDevice.find(params[:id])
    if @sck_device
      if @sck_device.update_attributes(params[:sck_device])
        flash[:success] = pat(:update_success, :model => 'Sck_device', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:sck_devices, :index)) :
          redirect(url(:sck_devices, :edit, :id => @sck_device.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'sck_device')
        render 'sck_devices/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'sck_device', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Sck_devices"
    sck_device = SckDevice.find(params[:id])
    if sck_device
      if sck_device.destroy
        flash[:success] = pat(:delete_success, :model => 'Sck_device', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'sck_device')
      end
      redirect url(:sck_devices, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'sck_device', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Sck_devices"
    unless params[:sck_device_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'sck_device')
      redirect(url(:sck_devices, :index))
    end
    ids = params[:sck_device_ids].split(',').map(&:strip)
    sck_devices = SckDevice.find(ids)
    
    if SckDevice.destroy sck_devices
    
      flash[:success] = pat(:destroy_many_success, :model => 'Sck_devices', :ids => "#{ids.to_sentence}")
    end
    redirect url(:sck_devices, :index)
  end
end
