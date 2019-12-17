class User < ApplicationRecord
  devise :trackable, :omniauthable, omniauth_providers: %i(google)
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :cards

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable


  protected
  def self.find_for_google(auth)
    user = User.find_by(email: auth.info.email)

    unless user
      user = User.new(name:     auth.info.name,
                          email: auth.info.email,
                          provider: auth.provider,
                          uid:      auth.uid,
                          token:    auth.credentials.token,
                          password: Devise.friendly_token[0, 20],
                          meta:     auth.to_yaml)
    end
    user
  end
end
