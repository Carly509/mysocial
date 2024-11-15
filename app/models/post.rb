class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many_attached :media_files

  validates :content, presence: true, unless: -> { media_files.attached? }
  validates :media_files, content_type: ['image/png', 'image/jpeg', 'video/mp4'],
                         size: { less_than: 100.megabytes }
end
