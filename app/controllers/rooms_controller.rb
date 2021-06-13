class RoomsController < ApplicationController
  before_action :check_dm_room, only: [:create_dm]
  before_action :check_mutual_follow, only: [:create_dm]
  before_action :set_book, only: [:index]
  

  def index
    @rooms = current_user.rooms
  end
  
  def create
  end
  
  def create_dm
    room = current_user.admin_rooms.build(is_direct_message: true)
    room.room_users.build([{user_id: current_user.id}, {user_id: @user.id}])
    room.save
    redirect_to room_path(room)
  end
  
  def show
    @room = Room.find(params[:id])
    @chat = Chat.new
    if @room.is_direct_message?
      @opponent_user = @room.opponent_for(current_user)
    end
  end
  

  def check_dm_room
    @user = User.find(params[:id])
    room = current_user.dm_room_for(@user)
    if room.present?
      redirect_to room_path(room)
    end
  end
  
  def check_mutual_follow
    unless current_user.mutual_follow?(@user)
      redirect_back(fallback_location: books_path)
    end
  end
  
end
