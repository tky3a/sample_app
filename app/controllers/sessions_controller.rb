class SessionsController < ApplicationController
  def new
  end

  def create
    # render 'new'
    user = User.find_by(email: params[:session][:email].downcase)#loginフォームに対応したsessionを取得
    if user && user.authenticate(params[:session][:password])#emailとpassword
      log_in user
      params[:session][remember_me] == '1'? remember(user) : forget(user)
      redirect_to user
    else
      flash.now[:danger] = "正しく入力してください"
      render 'new'
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end


end
