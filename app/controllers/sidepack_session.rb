Citizenscienceks::App.controllers :sidepack_data do
  layout :subpage

  get :index do
    @sidepack_sessions = SidepackSession.all
    render 'sidepack_sessions/index'
  end

  get :show do
    @sidepack_session = SidepackSession.find(params[:id])
    render 'sidepack_sessions/show'
  end

end
