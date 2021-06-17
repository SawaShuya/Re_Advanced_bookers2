class BooksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_book, only: [:index, :show, :edit, :update, :destroy]
  before_action :view_count, only: [:show]
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]
  before_action :set_week, only: [:index]
  

  def show
    @book_comment = BookComment.new
  end

  def index
    @books = Book.all.includes(:user).sort{|a, b| b.favorites.where(created_at: @period).count <=> a.favorites.where(created_at: @period).count}
  end

  def create
    @book = current_user.books.new(book_params)
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end

  def edit; end

  def update
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :body)
  end

  def ensure_correct_user
    unless @book.user == current_user
      redirect_to books_path
    end
  end
  
  def set_week
    from = Time.current.ago(6.days).at_beginning_of_day
    to = Time.current.at_end_of_day
    @period = from..to
  end
  
  def view_count
    @book.update(page_views: @book.page_views + 1)
  end
end
