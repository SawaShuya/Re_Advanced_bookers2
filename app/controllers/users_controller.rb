class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update]

  def show
    @user = User.find(params[:id])
    @books = @user.books
    @book = Book.new
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

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end
  
  def submit_count
    set_a_week
    set_last_week
    
    @today_counts, @yesterday_counts, @week_counts, @last_week_counts = 0, 0, 0, 0
    @daily_counts = [0, 0, 0, 0, 0, 0, 0]
    
    @count_books.each do |book|
      if Time.current.all_day.cover? book.created_at
        @today_counts += 1
        @daily_counts[6] += 1
      elsif Time.current.yesterday.all_day.cover? book.created_at
        @yesterday_counts += 1
        @daily_counts[5] += 1
      elsif @a_week.cover? book.created_at
        @week_counts += 1
        days_before = Time.current - book.created_at
        @daily_counts[6-days_before] += 1
      elsif @last_week.cover? book.created_at
        @last_week_counts += 1
      end
    end
  end
  
  def set_two_week
    from = Time.current.ago(13.days).at_beginning_of_day
    to = Time.current.at_end_of_day
    @two_week = from..to
  end
  
  def set_a_week
    from = Time.current.ago(6.days).at_beginning_of_day
    to = Time.current.at_end_of_day
    @a_week = from..to
  end
  
  def set_last_week
    from = Time.current.ago(13.days).at_beginning_of_day
    to = Time.current.ago(7.days).at_end_of_day
    @last_week = from..to
  end

end
