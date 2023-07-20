# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Landing page', type: :feature do
  describe 'as a registered user ' do
    before :each do
      @user1 = User.create!(name: 'Danny', email: 'danny123@grease.com', password: 'password')
      @user2 = User.create!(name: 'Sandy', email: 'sandy246@grease.com', password: 'something')
      @user3 = User.create!(name: 'Rizzo', email: 'rizzo678@grease.com', password: 'anotherPassword')
    end

    it 'can log in' do
      visit root_path
      expect(page).to have_link('Log In')

      click_link 'Log In'
      expect(current_path).to eq(login_path)

      fill_in :email, with: @user1.email
      fill_in :password, with: @user1.password
      click_button 'Log In'

      expect(page).to have_content('Welcome, Danny!')
      expect(current_path).to eq(user_path(@user1.id))
    end

    it 'can not log in with bad credentials' do
      visit root_path
      expect(page).to have_link('Log In')

      click_link "Log In"
      expect(current_path).to eq(login_path)

      fill_in :email, with: @user2.email
      fill_in :password, with: 'wrong password'
      click_button 'Log In'

      expect(current_path).to eq(login_path)
      expect(page).to_not have_content('Welcome, Sandy!')
      expect(page).to have_content('Invalid Credentials. Please try again.')
    end
  end

  describe 'log out functionality' do
    before :each do
      @user1 = User.create!(name: 'Danny', email: 'danny123@grease.com', password: 'password')
      visit login_path
      fill_in :email, with: @user1.email
      fill_in :password, with: @user1.password
      click_button 'Log In'
    end

    it 'logged in and other buttons not displayed' do
      expect(current_path).to eq(user_path(@user1.id))
      visit root_path
      
      expect(page).to_not have_link('Log In')
      expect(page).to_not have_link('Create a New User')
      expect(page).to have_link('Log Out')
    end

    it 'deletes session and returns to landing page' do
      visit root_path
      click_link 'Log Out'

      expect(current_path).to eq(root_path)
      expect(page).to have_link('Log In')
      expect(page).to have_link('Create a New User')
      expect(page).to_not have_link('Log Out')
      expect(page).to have_content('Successful Logout!')
    end
  end

  describe 'as a visitor' do
    it 'does not display content' do
      visit root_path

      expect(page).to have_content('Viewing Party')
      expect(page).to have_link('Create a New User')
      expect(page).to_not have_content('Existing Users')
      expect(page).to_not have_content('Danny')
    end

    it 'cannot go to dashboard page' do
      user = User.create!(name: 'Danny', email: 'yourma@aol.com', password: 'password')
      visit user_path(user.id)

      expect(current_path).to eq(root_path)
      expect(page).to have_content('You must be logged in to view this page.')
    end
  end
end
