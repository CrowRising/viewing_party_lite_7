require 'rails_helper'

RSpec.describe 'User Registration' do
  describe 'as a user when I visit the registration page' do
    it 'display a form to register' do
      visit '/register'

      within '#registration-form' do
        expect(page).to have_field('Name')
        expect(page).to have_field('Email')
        expect(page).to have_content('Name')
        expect(page).to have_content('Email')
        expect(page).to have_button('Save')
      end
    end
  end
end