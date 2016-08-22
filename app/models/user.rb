class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable
  acts_as_paranoid

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid)
      .first_or_create { |u| user_hash(u, auth) }
  end

  def self.user_hash(user, auth)
    user.provider = auth.provider
    user.uid = auth.uid
    user.name = auth.info.name
    user.email = auth.info.email
    user.password = Devise.friendly_token[0, 20]
    user
  end
end
