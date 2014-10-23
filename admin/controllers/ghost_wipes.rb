Citizenscienceks::Admin.controllers :ghost_wipes do
  get :index do
    @title = "Ghost_wipes"
    @ghost_wipes = GhostWipe.all
    render 'ghost_wipes/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'ghost_wipe')
    @ghost_wipe = GhostWipe.new
    render 'ghost_wipes/new'
  end

  post :create do
    @ghost_wipe = GhostWipe.new(params[:ghost_wipe])
    if @ghost_wipe.save
      @title = pat(:create_title, :model => "ghost_wipe #{@ghost_wipe.id}")
      flash[:success] = pat(:create_success, :model => 'GhostWipe')
      params[:save_and_continue] ? redirect(url(:ghost_wipes, :index)) : redirect(url(:ghost_wipes, :edit, :id => @ghost_wipe.id))
    else
      @title = pat(:create_title, :model => 'ghost_wipe')
      flash.now[:error] = pat(:create_error, :model => 'ghost_wipe')
      render 'ghost_wipes/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "ghost_wipe #{params[:id]}")
    @ghost_wipe = GhostWipe.find(params[:id])
    if @ghost_wipe
      render 'ghost_wipes/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'ghost_wipe', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "ghost_wipe #{params[:id]}")
    @ghost_wipe = GhostWipe.find(params[:id])
    if @ghost_wipe
      if @ghost_wipe.update_attributes(params[:ghost_wipe])
        flash[:success] = pat(:update_success, :model => 'Ghost_wipe', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:ghost_wipes, :index)) :
          redirect(url(:ghost_wipes, :edit, :id => @ghost_wipe.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'ghost_wipe')
        render 'ghost_wipes/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'ghost_wipe', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Ghost_wipes"
    ghost_wipe = GhostWipe.find(params[:id])
    if ghost_wipe
      if ghost_wipe.destroy
        flash[:success] = pat(:delete_success, :model => 'Ghost_wipe', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'ghost_wipe')
      end
      redirect url(:ghost_wipes, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'ghost_wipe', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Ghost_wipes"
    unless params[:ghost_wipe_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'ghost_wipe')
      redirect(url(:ghost_wipes, :index))
    end
    ids = params[:ghost_wipe_ids].split(',').map(&:strip)
    ghost_wipes = GhostWipe.find(ids)
    
    if GhostWipe.destroy ghost_wipes
    
      flash[:success] = pat(:destroy_many_success, :model => 'Ghost_wipes', :ids => "#{ids.to_sentence}")
    end
    redirect url(:ghost_wipes, :index)
  end
end
