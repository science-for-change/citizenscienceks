Citizenscienceks::Admin.controllers :diffusion_tubes do
  get :index do
    @title = "Diffusion_tubes"
    @diffusion_tubes = DiffusionTube.all
    render 'diffusion_tubes/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'diffusion_tube')
    @diffusion_tube = DiffusionTube.new
    render 'diffusion_tubes/new'
  end

  post :create do
    @diffusion_tube = DiffusionTube.new(params[:diffusion_tube])
    if @diffusion_tube.save
      @title = pat(:create_title, :model => "diffusion_tube #{@diffusion_tube.id}")
      flash[:success] = pat(:create_success, :model => 'DiffusionTube')
      params[:save_and_continue] ? redirect(url(:diffusion_tubes, :index)) : redirect(url(:diffusion_tubes, :edit, :id => @diffusion_tube.id))
    else
      @title = pat(:create_title, :model => 'diffusion_tube')
      flash.now[:error] = pat(:create_error, :model => 'diffusion_tube')
      render 'diffusion_tubes/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "diffusion_tube #{params[:id]}")
    @diffusion_tube = DiffusionTube.find(params[:id])
    if @diffusion_tube
      render 'diffusion_tubes/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'diffusion_tube', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "diffusion_tube #{params[:id]}")
    @diffusion_tube = DiffusionTube.find(params[:id])
    if @diffusion_tube
      if @diffusion_tube.update_attributes(params[:diffusion_tube])
        flash[:success] = pat(:update_success, :model => 'Diffusion_tube', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:diffusion_tubes, :index)) :
          redirect(url(:diffusion_tubes, :edit, :id => @diffusion_tube.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'diffusion_tube')
        render 'diffusion_tubes/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'diffusion_tube', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Diffusion_tubes"
    diffusion_tube = DiffusionTube.find(params[:id])
    if diffusion_tube
      if diffusion_tube.destroy
        flash[:success] = pat(:delete_success, :model => 'Diffusion_tube', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'diffusion_tube')
      end
      redirect url(:diffusion_tubes, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'diffusion_tube', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Diffusion_tubes"
    unless params[:diffusion_tube_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'diffusion_tube')
      redirect(url(:diffusion_tubes, :index))
    end
    ids = params[:diffusion_tube_ids].split(',').map(&:strip)
    diffusion_tubes = DiffusionTube.find(ids)
    
    if DiffusionTube.destroy diffusion_tubes
    
      flash[:success] = pat(:destroy_many_success, :model => 'Diffusion_tubes', :ids => "#{ids.to_sentence}")
    end
    redirect url(:diffusion_tubes, :index)
  end
end
