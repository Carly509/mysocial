class User < ApplicationRecord

  after_create :create_profile

  private

  def create_profile
    Profile.create(
      user: self,
      username: "user_#{self.id}",  # Default username
    )
  end

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :profile
  has_many :posts
  has_many :comments
  has_many :likes

  has_many :active_follows, class_name: "Follow",
                           foreign_key: "follower_id",
                           dependent: :destroy
  has_many :passive_follows, class_name: "Follow",
                            foreign_key: "followed_id",
                            dependent: :destroy

  has_many :following, through: :active_follows, source: :followed
  has_many :followers, through: :passive_follows, source: :follower

  has_many :sent_messages, class_name: "Message",
                          foreign_key: "sender_id"
  has_many :received_messages, class_name: "Message",
                              foreign_key: "recipient_id"

  has_one_attached :avatar
  has_many_attached :media_files
end
