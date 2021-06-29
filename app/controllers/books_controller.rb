class BooksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_book, only: [:index, :show, :edit, :update, :destroy]
  before_action :view_count, only: [:show]
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]
  before_action :set_books, only: [:index]
  

  def show
    @book_comment = BookComment.new
  end

  def index; end

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
    params.require(:book).permit(:title, :body, :evaluation)
  end

  def ensure_correct_user
    unless @book.user == current_user
      redirect_to books_path
    end
  end
  
  
  
  def view_count
    @book.update(page_views: @book.page_views + 1)
  end
end
