class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :edit, :update, :book_count]
  before_action :ensure_correct_user, only: [:edit, :update]

  def show
    @books = @user.books
    @book = Book.new
    @now = Time.current
    set_two_week
    @count_books = @books.where(created_at: @two_week)
    submit_count
  end

  def index
    @users = User.all
    @book = Book.new
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "You have updated user successfully."
    else
      render "edit"
    end
  end
  
  def book_count
    @counts = @user.count_books_for(params[:date].to_date)
    respond_to do |format|
      format.html {redirect_back(fallback_location: books_path)}
      format.js
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end
  
  def set_user
    @user = User.find(params[:id])
  end

  def ensure_correct_user
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end
  
  def submit_count
    set_a_week
    set_last_week
    
    @today_counts, @yesterday_counts, @week_counts, @last_week_counts = 0, 0, 0, 0
    gon.daily_counts = [0, 0, 0, 0, 0, 0, 0]
    
    @count_books.each do |book|
      if @now.all_day.cover? book.created_at
        @today_counts += 1
        @week_counts += 1
        gon.daily_counts[6] += 1
      elsif @now.yesterday.all_day.cover? book.created_at
        @yesterday_counts += 1
        @week_counts += 1
        gon.daily_counts[5] += 1
      elsif @a_week.cover? book.created_at
        @week_counts += 1
        days_before = (@now.to_date - book.created_at.to_date).to_i
        gon.daily_counts[6 - days_before] += 1
      elsif @last_week.cover? book.created_at
        @last_week_counts += 1
      end
    end
  end
  
  def set_two_week
    from = @now.ago(13.days).at_beginning_of_day
    to = @now.at_end_of_day
    @two_week = from..to
  end
  
  def set_a_week
    from = @now.ago(6.days).at_beginning_of_day
    to = @now.at_end_of_day
    @a_week = from..to
    
    gon.days = []
    for i in 1..5 do
      i = 7 - i
      gon.days.push(@now.ago(i.days).strftime('%m/%d'))
      
    end
    gon.days.push('yesterday', 'today')
  end
  
  def set_last_week
    from = @now.ago(13.days).at_beginning_of_day
    to = @now.ago(7.days).at_end_of_day
    @last_week = from..to
  end

end
