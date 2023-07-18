class SessionsController < ApplicationController
  def logout
    session.delete(:user_id)
    flash[:message] = 'Successful Logout'
    redirect_to root_path
  end
end