class RelationshipsController < ApplicationController
  before_action :set_book, only: [:following, :followed]
  before_action :set_user, only: [:create, :destroy, :following, :followed]

  def create
    relationship = @user.followed.new(follower_id: current_user.id)
    relationship.save
    redirect_back(fallback_location: books_path)
  end
  
  def destroy
    relationship = @user.followed.find_by(follower_id: current_user.id)
    relationship.destroy
    redirect_back(fallback_location: books_path)
  end
  
  def following; end
  
  def followed; end
  
  def set_user
    @user = User.find(params[:user_id])
  end
  
end
