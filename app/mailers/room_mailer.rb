class RoomMailer < ApplicationMailer
    
  def group_email(users, title, content)
    @content = content
    mail to: users.map{|u| u.email}
    mail subject: title
    # render :group_email
  end

end
