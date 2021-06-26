class RoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_dm_room, only: [:create_dm]
  before_action :check_mutual_follow, only: [:create_dm]
  before_action :set_book, only: [:index, :chat_rooms, :detail]
  before_action :set_room, only: [:new, :show, :edit, :update, :detail, :send_email, :new_email]
  before_action :check_collect_user, only: [:chat_rooms]
  

  def index
    @rooms = Room.where(is_direct_message: false)
  end
  
  def chat_rooms
    @rooms = current_user.rooms
  end

  def new; end
  
  
  def create
    @room = current_user.admin_rooms.build(room_params)
    @room.room_users.build(user_id: current_user.id)
    if @room.save
      redirect_to room_path(@room)
    else
      render 'new'
    end
    
  end
  
  def create_dm
    room = current_user.admin_rooms.build(is_direct_message: true, name: @user.name)
    room.room_users.build([{user_id: current_user.id}, {user_id: @user.id}])
    room.save
    redirect_to room_path(room)
  end
  
  def show
    @chat = Chat.new
    if @room.is_direct_message?
      @opponent_user = @room.opponent_for(current_user)
    end
  end
  
  def edit; end
    
  def update
    @room.update(room_params)
    redirect_to room_detail_path(@room)
  end
  
  def detail
    @room = Room.find(params[:room_id])
    if @room.is_direct_message
      redirect_back(fallback_location: rooms_path)
    end
  end
  
  def send_email
    @room = Room.find(params[:room_id])
    @users = @room.users
    @title = params[:title]
    @content = params[:content]
    if @title.present? && @content.present? && RoomMailer.group_email(@users, @title, @content).deliver
      render 'rooms/finish_email'
    else
      render :new_email
    end
  end
  
  def new_email
  end
  
  private
  def room_params
    params.require(:room).permit(:name, :image, :introduction)
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
  
  def set_room
    if params[:room_id].present?
      @room = Room.find(params[:room_id])
    else
      @room = Room.find_or_initialize_by(id: params[:id])
    end
  end
  
  def check_admin
    unless @room.admin_id == current_user.id
      redirect_back(fallback_location: rooms_path)
    end
  end
  
  def check_collect_user
    user = User.find(params[:user_id])
    unless user == current_user
      redirect_back(fallback_location: rooms_path)
    end
  end
  
  
end
