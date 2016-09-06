class User < ApplicationRecord
  has_secure_password
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  has_many :ideas, dependent: :nullify

  has_many :likes, dependent: :destroy
  has_many :liked_ideas, through: :likes, source: :idea

  has_many :members, dependent: :destroy
  has_many :membered_ideas, through: :follows, source: :idea

  has_many :comments, dependent: :destroy

  validates :email, presence: true, uniqueness: {case_sensitive: false}, format: VALID_EMAIL_REGEX

  def full_name
    "#{first_name} #{last_name}".squeeze(" ").strip.titleize
  end

end
