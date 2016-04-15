Citizenscienceks::Admin.controllers :uploads do
  get :index do
    @title = "Uploads"
    @uploads = Upload.all
    render 'uploads/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'upload')
    @upload = Upload.new
    render 'uploads/new'
  end

  post :create do
    @upload = Upload.new(params[:upload])
    if @upload.save
      @title = pat(:create_title, :model => "upload #{@upload.id}")
      flash[:success] = pat(:create_success, :model => 'Upload')
      params[:save_and_continue] ? redirect(url(:uploads, :index)) : redirect(url(:uploads, :edit, :id => @upload.id))
    else
      @title = pat(:create_title, :model => 'upload')
      flash.now[:error] = pat(:create_error, :model => 'upload')
      render 'uploads/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "upload #{params[:id]}")
    @upload = Upload.find(params[:id])
    if @upload
      render 'uploads/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'upload', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "upload #{params[:id]}")
    @upload = Upload.find(params[:id])
    if @upload
      if @upload.update_attributes(params[:upload])
        flash[:success] = pat(:update_success, :model => 'Upload', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:uploads, :index)) :
          redirect(url(:uploads, :edit, :id => @upload.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'upload')
        render 'uploads/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'upload', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Uploads"
    upload = Upload.find(params[:id])
    if upload
      if upload.destroy
        flash[:success] = pat(:delete_success, :model => 'Upload', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'upload')
      end
      redirect url(:uploads, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'upload', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Uploads"
    unless params[:upload_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'upload')
      redirect(url(:uploads, :index))
    end
    ids = params[:upload_ids].split(',').map(&:strip)
    uploads = Upload.find(ids)
    
    if Upload.destroy uploads
    
      flash[:success] = pat(:destroy_many_success, :model => 'Uploads', :ids => "#{ids.to_sentence}")
    end
    redirect url(:uploads, :index)
  end
end
