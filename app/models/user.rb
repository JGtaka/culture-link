class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable,
         omniauth_providers: [ :google_oauth2 ]

  has_many :favorites, dependent: :destroy
  has_many :schedules, dependent: :destroy
  has_many :quiz_results, dependent: :destroy
  has_many :article_views, dependent: :destroy

  validates :name, presence: true

  def self.from_omniauth(auth)
    return nil unless auth.info.email_verified

    user = find_by(provider: auth.provider, uid: auth.uid)
    return user if user

    return nil if User.exists?(email: auth.info.email)

    create do |u|
      u.provider = auth.provider
      u.uid = auth.uid
      u.email = auth.info.email
      u.name = auth.info.name
      u.password = SecureRandom.hex(16)
    end
  end

  def password_required?
    super && provider.blank?
  end

  def password_changeable?
    provider.blank?
  end
end
