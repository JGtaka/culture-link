class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, :trackable,
         omniauth_providers: [ :google_oauth2 ]

  enum :role, { general: 0, admin: 1 }

  has_many :favorites, dependent: :destroy
  has_many :schedules, dependent: :destroy
  has_many :quiz_results, dependent: :destroy
  has_many :article_views, dependent: :destroy

  scope :active_users,    -> { where(suspended_at: nil) }
  scope :suspended,       -> { where.not(suspended_at: nil) }
  scope :recently_active, -> { where(current_sign_in_at: 30.days.ago..) }

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

  def suspended?
    suspended_at.present?
  end

  # IPアドレスを記録しないためオーバーライド（IPカラムは未作成）
  def update_tracked_fields(_request)
    old_current, new_current = current_sign_in_at, Time.current
    self.last_sign_in_at    = old_current || new_current
    self.current_sign_in_at = new_current
    self.sign_in_count      = (sign_in_count || 0) + 1
  end
end
