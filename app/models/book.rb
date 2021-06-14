class Book < ApplicationRecord
	belongs_to :user
	validates :title,presence:true
	validates :body,presence:true,length:{maximum:200}
	
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
	
  def submit_count(book, now, today_counts, yesterday_counts, week_counts, last_week_counts)
    if now.all_day.cover? book.created_at
      today_counts += 1
    elsif now.yesterday.all_day.cover? book.created_at
      yesterday_counts += 1
    elsif now.all_week.cover? book.created_at
      week_counts += 1
    elsif now.prev_week.all_week.cover? book.created_at
      last_week_counts += 1
    end
    return today_counts, yesterday_counts, week_counts, last_week_counts
  end

end
