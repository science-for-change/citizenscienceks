Citizenscienceks::Admin.controllers :sites do
  get :index do
    @title = "Sites"
    @sites = Site.all
    render 'sites/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'site')
    @site = Site.new
    render 'sites/new'
  end

  post :create do
    @site = Site.new(params[:site])
    if @site.save
      @title = pat(:create_title, :model => "site #{@site.id}")
      flash[:success] = pat(:create_success, :model => 'Site')
      params[:save_and_continue] ? redirect(url(:sites, :index)) : redirect(url(:sites, :edit, :id => @site.id))
    else
      @title = pat(:create_title, :model => 'site')
      flash.now[:error] = pat(:create_error, :model => 'site')
      render 'sites/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "site #{params[:id]}")
    @site = Site.find(params[:id])
    if @site
      render 'sites/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'site', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "site #{params[:id]}")
    @site = Site.find(params[:id])
    if @site
      if @site.update_attributes(params[:site])
        flash[:success] = pat(:update_success, :model => 'Site', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:sites, :index)) :
          redirect(url(:sites, :edit, :id => @site.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'site')
        render 'sites/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'site', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Sites"
    site = Site.find(params[:id])
    if site
      if site.destroy
        flash[:success] = pat(:delete_success, :model => 'Site', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'site')
      end
      redirect url(:sites, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'site', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Sites"
    unless params[:site_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'site')
      redirect(url(:sites, :index))
    end
    ids = params[:site_ids].split(',').map(&:strip)
    sites = Site.find(ids)
    
    if Site.destroy sites
    
      flash[:success] = pat(:destroy_many_success, :model => 'Sites', :ids => "#{ids.to_sentence}")
    end
    redirect url(:sites, :index)
  end
end
