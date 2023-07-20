class SessionsController < ApplicationController
  def logout
    # require 'pry'; binding.pry
    session.delete(:user_id)
    flash[:message] = 'Successful Logout!'
    redirect_to root_path
  end
end