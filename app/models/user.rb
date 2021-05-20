class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[google_oauth2]

  has_many :sns_credentials, dependent: :destroy

  def self.from_omniauth(auth)
    user = where(email: auth.info.email).first_or_create do |user|
      user.password = Devise.friendly_token[0,20]
    end
    user.sns_credentials.where(provider: auth.provider, uid: auth.uid).first_or_create do |sns_credential|
      sns_credential.user_id = user.id
    end
    user
  end
end
