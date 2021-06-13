class FavoritesController < ApplicationController
  def create
    @book = Book.find(params[:book_id])
    favorite = Favorite.new(book_id: @book.id, user_id: current_user.id)
    respond_to do |format|
      if favorite.save
        format.html {redirect_back(fallback_location: books_path)}
        format.js
      end
    end
    
  end
  
  def destroy
    @book = Book.find(params[:book_id])
    favorite = Favorite.find_by(book_id: @book.id, user_id: current_user.id)
    respond_to do |format|
      if favorite.destroy
        format.html {redirect_back(fallback_location: books_path)}
        format.js
      end
    end
  end
end
