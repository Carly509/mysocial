class Profile < ApplicationRecord
  belongs_to :user
  has_one_attached :avatar

  validates :username, presence: true, uniqueness: true,
            format: { with: /\A[a-zA-Z0-9_]+\z/, message: "only allows letters, numbers, and underscores" }
  validates :bio, length: { maximum: 500 }

  def avatar_url
    if avatar.attached?
      Rails.application.routes.url_helpers.url_for(avatar)
    else
      "default_avatar.png"
    end
  end
end
