module PostsHelper
  def waiting? post
    user_owner? post and post.accepted == false
  end

  def user_owner? post
    (user_signed_in? and current_user.owner? post) or admin_signed_in?
  end


end
