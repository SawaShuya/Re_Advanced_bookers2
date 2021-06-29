class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  def set_book
    @book =  Book.find_or_initialize_by(id: params[:id])
  end
  
  def set_books
    if params[:sort_order]=="weekly_favorite"
      set_week
      @books = Book.all.includes(:user).sort{|a, b| b.favorites.where(created_at: @period).count <=> a.favorites.where(created_at: @period).count}
    elsif params[:sort_order]=="favorite"
      @books = Book.all.includes(:user).sort{|a, b| b.favorites.count <=> a.favorites.count}
    else
      @books = Book.all.includes(:user).order(id: :desc)
    end
  end
  
  def set_week
    from = Time.current.ago(6.days).at_beginning_of_day
    to = Time.current.at_end_of_day
    @period = from..to
  end

  private

  def after_sign_in_path_for(resource)
    user_path(resource)
  end

  def after_sign_out_path_for(resource)
    root_path
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email])
  end
end
