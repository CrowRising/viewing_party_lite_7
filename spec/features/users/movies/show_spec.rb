# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Movie Show Page' do
  describe 'as a user when I visit the movie show page' do
    before :each do
      @user1 = User.create!(name: 'Danny', email: 'flyfish213@aol.com', password: 'password')
      visit login_path
      fill_in :email, with: @user1.email
      fill_in :password, with: @user1.password
      click_button 'Log In'
      visit "/users/#{@user1.id}/movie/238"
    end

    it 'I see the movie title, vote average, runtime, genre and summary', :vcr do
      within '#movie-details' do
        expect(page).to have_content('The Godfather')
        expect(page).to have_content('8.7')
        expect(page).to have_content('2h 55m')
        expect(page).to have_content('Spanning the years 1945 to 1955, a chronicle of the fictional Italian-American Corleone crime family. When organized crime family patriarch, Vito Corleone barely survives an attempt on his life, his youngest son, Michael steps in to take care of the would-be killers, launching a campaign of bloody revenge.')
        expect(page).to have_content('Crime')
        expect(page).to have_content('Drama')
      end
    end

    it 'I see the top ten cast members for the movie', :vcr do
      within '#movie-details' do
        expect(page).to have_content('Marlon Brando as Don Vito Corleone')
        expect(page).to have_content('John Marley as Jack Woltz')
        expect(page).to_not have_content('Richard Conte as Barzini')
      end
    end

    it 'displays total count of reviews', :vcr do
      within '#movie-reviews' do
        expect(page).to have_content(5)
      end
    end

    it 'displays each review with author and content', :vcr do
      within '#movie-reviews' do
        expect(page).to have_content('futuretv')
        expect(page).to have_content('The Godfather is a film considered by most to be one of the greatest ever made.')
        expect(page).to have_content('Suresh Chidurala')
        expect(page).to have_content('Great Movie **Ever**')
      end
    end

    it 'has a button to create a viewing party', :vcr do
      within '#create-party' do
        expect(page).to have_link('Create Viewing Party')
        click_link 'Create Viewing Party'
      end
      expect(current_path).to eq(new_user_movie_viewing_party_path(@user1, 238))
    end

    it 'has a button to return to the Discover Page', :vcr do
      within '#discover' do
        expect(page).to have_button('Back to Discover')
        click_button 'Back to Discover'
      end
      expect(current_path).to eq(user_discover_index_path(@user1))
    end
  end

  describe 'as a visitor when I visit the movie show page' do
    it 'cannot create a viewing party if not logged in', :vcr do 
      @user2 = User.create!(name: 'Danny', email: 'yourmom@aol.com', password: 'password') 
      visit "/users/#{@user2.id}/movie/238"
     
      expect(current_path).to eq(root_path)
      expect(page).to have_content('You must be logged in to view this page.')
    end
  end
end
