class Room < ApplicationRecord
  has_many :room_users, dependent: :destroy
  has_many :users, through: :room_users
  
  has_many :chats, dependent: :destroy
  
  attachment :image
  
  validates :name, presence: true
  
  def opponent_for(user)
    room_users.where.not(user_id: user.id).first.user
  end
  
end
