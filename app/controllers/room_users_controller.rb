class RoomUsersController < ApplicationController
  before_action :set_room
  
  def create
    room_user = current_user.room_users.new(room_id: @room.id)
    room_user.save
    redirect_back(fallback_location: rooms_path)
  end

  def destroy
    room_user = current_user.room_users.find_by(room_id: @room.id)
    room_user.destroy
    redirect_back(fallback_location: rooms_path)
  end
  
  private
  def set_room
    @room = Room.find(params[:room_id])
  end
end
