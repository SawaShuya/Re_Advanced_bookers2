class Book < ApplicationRecord
	belongs_to :user
	validates :title,presence:true
	validates :body,presence:true,length:{maximum:200}
	
	validates :evaluation, numericality: {
    less_than_or_equal_to: 5,
    greater_than_or_equal_to: 1
  }, presence: true
	
	has_many :favorites, dependent: :destroy
	has_many :book_comments, dependent: :destroy
	
	def favorited_by?(user)
		favorites.where(user_id: user.id).exists?
	end
	
	def self.search_contents(word, range)
		if range == 0
			self.where(["title LIKE?", "#{word}"])
		elsif range == 1
			self.where(['title LIKE?', "#{word}%"])
		elsif range == 2
			self.where(['title LIKE?', "%#{word}"])
		elsif range == 3
			self.where(['title LIKE?', "%#{word}%"])
		end
	end

end
