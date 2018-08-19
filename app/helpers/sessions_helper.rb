module SessionsHelper
   # 渡されたユーザーでログインする
   def log_in(user)
    session[:user_id] = user.id
   end

   # ユーザーのセッションを永続的にする
   def remember(user)
    user.remember #userのログイン維持
    cookies.permanent.signed[:user_id] = user.id #user_idのcookieを暗号化
    cookies.permanent[:remember_token] = user.remember_token #remember_tokenを暗号化
   end

   # 記憶トークンcookieに対応するユーザーを返す
   def current_user
   #(ユーザーIDにユーザーIDのセッションを代入した結果)ユーザーIDのセッションが存在すれば次の処理を行う
     if (user_id = session[:user_id])
       @current_user ||= User.find_by(id: user_id) #current_user(現在のユーザー)が未定義の場合、user_idを代入する
    #　違う場合(認証しているユーザーIDがあれば次の処理を行う)
    elsif cookies.signed[:user_id]
        user = User.find_by(id: user_id) #ユーザーIDを検出
      if user && user.authenticated?(cookies[:remember_token]) #もし、userかつ、userのauthenticatedが存在していれば
        log_in user #session
        @current_user = user #現在ユーザーを記憶
      end
    end
   end


   # 現在ログイン中のユーザーを返す (いる場合)
   def current_user
     @current_user ||= User.find_by(id: session[:user_id])
   end

   # ユーザーがログインしていればtrue、その他ならfalseを返す
   def logged_in?
    !current_user.nil?
   end

   #永続的セッションを破棄する
   def forget(user)
     user.forget #ヘルパーのforgetを呼び出し
     cookies.delete(:user_id)
     cookies.delete(:remember_token)
   end

    # 現在のユーザーをログアウトする
    def log_out
      forget(current_user)
      session.delete(:user_id)
      @current_user = nil #今のユーザーを空にする
    end
end
