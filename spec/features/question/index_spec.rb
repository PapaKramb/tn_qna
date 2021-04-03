require 'rails_helper'

feature 'User can view question' do
  given(:user) { create(:user) }
  given!(:questions) { create_list(:question, 3, user: user) }

  scenario 'view list question' do
    visit questions_path
    
    # save_and_open_page
    questions.each do |question|
      expect(page).to have_content question.title
      expect(page).to have_content question.body
    end
  end
end
