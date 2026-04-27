class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, :trackable,
         omniauth_providers: [ :google_oauth2, :line ]

  enum :role, { general: 0, admin: 1 }

  has_many :favorites, dependent: :destroy
  has_many :schedules, dependent: :destroy
  has_many :quiz_results, dependent: :destroy
  has_many :article_views, dependent: :destroy

  scope :active_users, -> { where(suspended_at: nil) }
  scope :suspended,    -> { where.not(suspended_at: nil) }

  # lambdaだと評価タイミングが誤解されやすいため、意図を明示するクラスメソッドとして定義
  def self.recently_active
    where(current_sign_in_at: 30.days.ago..)
  end

  validates :name, presence: true

  # IPアドレスを記録しない（セッターで値を破棄）
  def current_sign_in_ip=(_value); end
  def last_sign_in_ip=(_value); end

  def self.from_omniauth(auth)
    # email_verifiedはGoogle固有のフィールド。LINEはverify APIで検証済みなので不要
    return nil if auth.provider == "google_oauth2" && !auth.info.email_verified
    return nil if auth.info.email.blank?

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

  # LINEログインでemailが取得できなかったときの補完用
  # ユーザーが入力したメアドで新規作成する
  def self.create_from_omniauth_with_email(auth, email)
    return nil if email.blank?
    return nil if exists?(email: email)

    create do |u|
      u.provider = auth.provider
      u.uid = auth.uid
      u.email = email
      u.name = auth.info.name.presence || "ユーザー"
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

  # Devise: 停止中ユーザーは認証不可にする
  def active_for_authentication?
    super && !suspended?
  end

  def inactive_message
    suspended? ? :suspended : super
  end
end
