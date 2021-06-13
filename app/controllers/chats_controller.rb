class ChatsController < ApplicationController
  def create
    chat = current_user.chats.new(chat_params)
    chat.save
    redirect_back(fallback_location: books_path)
  end
  
  def chat_params
    params.require(:chat).permit(:content, :room_id)
  end
end
