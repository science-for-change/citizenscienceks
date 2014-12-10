Citizenscienceks::Admin.controllers :blog_posts do
  get :index do
    @title = "Blog_posts"
    @blog_posts = BlogPost.all
    render 'blog_posts/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'blog_post')
    @blog_post = BlogPost.new
    render 'blog_posts/new'
  end

  post :create do
    @blog_post = BlogPost.new(params[:blog_post])
    @blog_post.account = current_account
    if @blog_post.save
      @title = pat(:create_title, :model => "blog_post #{@blog_post.id}")
      flash[:success] = pat(:create_success, :model => 'BlogPost')
      params[:save_and_continue] ? redirect(url(:blog_posts, :index)) : redirect(url(:blog_posts, :edit, :id => @blog_post.id))
    else
      @title = pat(:create_title, :model => 'blog_post')
      flash.now[:error] = pat(:create_error, :model => 'blog_post')
      render 'blog_posts/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "blog_post #{params[:id]}")
    @blog_post = BlogPost.find(params[:id])
    if @blog_post
      render 'blog_posts/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'blog_post', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "blog_post #{params[:id]}")
    @blog_post = BlogPost.find(params[:id])
    if @blog_post
      if @blog_post.update_attributes(params[:blog_post])
        flash[:success] = pat(:update_success, :model => 'Blog_post', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:blog_posts, :index)) :
          redirect(url(:blog_posts, :edit, :id => @blog_post.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'blog_post')
        render 'blog_posts/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'blog_post', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Blog_posts"
    blog_post = BlogPost.find(params[:id])
    if blog_post
      if blog_post.destroy
        flash[:success] = pat(:delete_success, :model => 'Blog_post', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'blog_post')
      end
      redirect url(:blog_posts, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'blog_post', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Blog_posts"
    unless params[:blog_post_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'blog_post')
      redirect(url(:blog_posts, :index))
    end
    ids = params[:blog_post_ids].split(',').map(&:strip)
    blog_posts = BlogPost.find(ids)
    
    if BlogPost.destroy blog_posts
    
      flash[:success] = pat(:destroy_many_success, :model => 'Blog_posts', :ids => "#{ids.to_sentence}")
    end
    redirect url(:blog_posts, :index)
  end
end
