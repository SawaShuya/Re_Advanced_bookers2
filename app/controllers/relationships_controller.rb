class RelationshipsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_book, only: [:following, :followed]
  before_action :set_user, only: [:create, :destroy, :following, :followed]

  def create
    relationship = @user.followed.new(follower_id: current_user.id)
    respond_to do |format|
      if relationship.save
        set_users
        format.html {redirect_back(fallback_location: books_path)}
        format.js
      end
    end
  end
  
  def destroy
    relationship = @user.followed.find_by(follower_id: current_user.id)
    respond_to do |format|
      if relationship.destroy
        set_users
        format.html {redirect_back(fallback_location: books_path)}
        format.js
      end
    end
  end
  
  def following; end
  
  def followed; end
  
  def set_user
    @user = User.find(params[:user_id])
  end
  
  def set_users
    @page = params[:page_from]
    if @page == "index"
      @users = User.all
      @display_user = current_user
    elsif @page == "following"
      @display_user = User.find(params[:display_user_id])
      @users = @display_user.following_users
    elsif @page == "followed"
      @display_user = User.find(params[:display_user_id])
      @users = @display_user.followed_users
    else
      @display_user = @user
    end
  end
      
end
