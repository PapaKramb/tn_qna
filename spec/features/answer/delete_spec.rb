require 'rails_helper'

feature 'User can destroy answer' do
  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: author) }

  describe 'Authenticated user' do
    scenario 'author delete answer' do
      sign_in(author)
      visit question_path(question)

      expect(page).to have_content "MyBody"
      click_on 'Delete answer'

      # save_and_open_page
      expect(page).not_to have_content "MyBody"
      expect(page).to have_content 'Your answer was successfully deleted!'
    end

    scenario 'not author delete question' do
      sign_in(user)
      visit question_path(question)

      expect(page).to_not have_link 'Delete answer'
    end
  end

  scenario 'Unauthenticated user tries to delete answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Delete answer'
  end
end