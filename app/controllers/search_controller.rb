class SearchController < ApplicationController
  before_action :authenticate_user!
  before_action :set_params

  def search
    if @model == 'Book'
      @results = Book.search_contents(@word, @range)
    elsif @model == 'User'
      @results = User.search_contents(@word, @range)
    end
  end
  
  def set_params
    @word = params[:word]
    check_word
    @model = params[:model]
    @range = params[:range].to_i
  end
  
  def check_word
    if @word.blank?
      redirect_back(fallback_location: books_path)
    end
  end
end
