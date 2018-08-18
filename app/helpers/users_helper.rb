module UsersHelper
  # 引数で与えられたユーザーのGravatar画像を返す
  def gravatar_for(user)
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase) #gravatarのidを設定
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}" #gravatorのurlにidを紐づける
    image_tag(gravatar_url, alt: user.name, class: "gravatar") #ユーザーの画像を取得
  end
end
