class Idea < ApplicationRecord
  belongs_to :user

  has_many :comments, dependent: :destroy
  has_many :members, dependent: :destroy
  has_many :likes, dependent: :destroy

  validates :title, presence: true, uniqueness: {case_sensitive: false}
  validates :body, presence: true

  def self.search(v)
      where("title ILIKE ? OR body ILIKE ?", "%#{v}%", "%#{v}%")
  end

  def like_for(user)
    likes.find_by_user_id user
  end

  def member_for(user)
    members.find_by_user_id user
  end

  private

  def capitalize_title
    self.title = title.titleize if title
  end
end
