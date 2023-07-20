# frozen_string_literal: true

module Users
  class MovieController < ApplicationController
    def index
      @user = User.find(params[:user_id])
      @top_rated = if params['search'].present?
                     MovieFacade.keyword(params['search'])
                   else
                     MovieFacade.top_rated
                   end
    end

    def show
      if current_user
        @user = User.find(params[:user_id])
        @movie = MovieFacade.get_movie(params[:id])
        @cast = MovieFacade.top_ten_cast(params[:id])
        @reviews = MovieFacade.reviews(params[:id])
      else
        flash[:error] = 'You must be logged in to view this page.'
        redirect_to root_path
      end
    end
  end
end
