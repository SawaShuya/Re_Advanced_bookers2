class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books
  attachment :profile_image, destroy: false

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: { maximum: 50 }
  
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  
  has_many :follower, class_name: 'Relationship', foreign_key: 'follower_id', dependent: :destroy
  has_many :following_users, through: :follower, source: :followed
  
  has_many :followed, class_name: 'Relationship', foreign_key: 'followed_id', dependent: :destroy
  has_many :followed_users, through: :followed, source: :follower
  
  has_many :room_users, dependent: :destroy
  has_many :rooms, through: :room_users
  
  has_many :admin_rooms, class_name: 'Room', foreign_key: 'admin_id'
  
  has_many :chats
	
  def followed_by?(user)
    followed_users.where(id: user.id).exists?
  end
  
  def mutual_follow?(user)
    self.followed_by?(user) && user.followed_by?(self)
  end
  
  def self.search_contents(word, range)
  	if range == 0
  		self.where(['name LIKE?', "#{word}"])
  	elsif range == 1
  		self.where(['name LIKE?', "#{word}%"])
  	elsif range == 2
  		self.where(['name LIKE?', "%#{word}"])
  	elsif range == 3
  		self.where(['name LIKE?', "%#{word}%"])
  	end
  end
  
  def dm_room_for(user)
    my_dm_rooms_id = self.rooms.where(is_direct_message: true).pluck(:id)
    return user.rooms.find_by(id: [my_dm_rooms_id])
  end
  
  def count_books_for(date)
    self.books.where(created_at: date.all_day).count
  end
end
