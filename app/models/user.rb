class User < ApplicationRecord
  attr_accessor :remember_token
  before_save { self.email = email.downcase } # email属性を小文字に変換してメールアドレスの一意性を保証

  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i #メールアドレスのフォーマットを指定
  validates :email, presence: true, length: { maximum: 255 },
                  format: { with: VALID_EMAIL_REGEX },
                  uniqueness: { case_sensitive: false }
  has_secure_password #パスワードをハッシュ化する為必須
  validates :password, presence: true, length: { minimum: 6 } #パスワードのブランク禁止・最小値を設定


  # 渡された文字列のハッシュ値を返す
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                BCrypt::Engine.cost
                                                BCrypt::Password.create(string, cost: cost)
    end

  # ランダムなトークンを返す
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # 永続セッションのためにユーザーをデータベースに記憶する
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # 渡されたトークンがダイジェストと一致したらtrueを返す
  def authenticate?(remember_token)
    BCrytp::Password.new(remember_digest).is_password?(remember_token)#remember_digestとremember_tokenのパスワードが一致しているか確認している
  end

  #ユーザーのログイン情報を破棄する
  def forget
    update_attribute(:remember_digest, nil)
  end
end
