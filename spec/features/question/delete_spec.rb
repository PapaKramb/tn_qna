require 'rails_helper'

feature 'User can delete his question' do
  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given(:question) { create(:question, user: author) }

  describe 'Authenticated user' do
    scenario 'author delete question' do
      sign_in(author)
      visit question_path(question)

      expect(page).to have_content "MyString"
      expect(page).to have_content "MyText"
      click_on 'Delete question'

      expect(page).not_to have_content "MyString"
      expect(page).not_to have_content "MyText"
      expect(page).to have_content 'Your question was successfully deleted!'
    end

    scenario 'not author tries delete question' do
      sign_in(user)
      visit question_path(question)

      expect(page).to_not have_link 'Delete question'
    end
  end

  scenario 'unauthenticated user tries delete question' do
    visit question_path(question)

    expect(page).to_not have_link 'Delete question'
  end
end