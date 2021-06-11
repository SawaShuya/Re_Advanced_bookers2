class BookCommentsController < ApplicationController
  before_action :set_book
  def create
    book_comment = @book.book_comments.new(book_comment_params)
    book_comment.user_id = current_user.id
    book_comment.save
    redirect_back(fallback_location: books_path)
  end
  
  def destroy
    book_comment = @book.book_comments.find(params[:id])
    book_comment.destroy
    redirect_back(fallback_location: books_path)
  end
  
  def set_book
    @book = Book.find(params[:book_id])
  end

  
  private
  def book_comment_params
    params.require(:book_comment).permit(:content)
  end
end
