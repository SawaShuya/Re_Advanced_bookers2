class BookCommentsController < ApplicationController
  before_action :set_book
  def create
    book_comment = @book.book_comments.new(book_comment_params)
    book_comment.user_id = current_user.id
    respond_to do |format|
      if book_comment.save
        format.html {redirect_back(fallback_location: books_path)}
        format.js
      end
    end
  end
  
  def destroy
    book_comment = @book.book_comments.find(params[:id])
    respond_to do |format|
      if book_comment.destroy
        format.html {redirect_back(fallback_location: books_path)}
        format.js
      end
    end
  end
  
  def set_book
    @book = Book.find(params[:book_id])
  end

  
  private
  def book_comment_params
    params.require(:book_comment).permit(:content)
  end
end
