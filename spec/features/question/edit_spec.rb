require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct mistakes
  As an a author of question
  I'd like ot be able to edit my question
} do
  
  given!(:user) { create(:user) }
  given!(:author) { create(:user) }
  given!(:question) { create(:question, user: author) }

  scenario 'Unauthenticated can not edit question' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user', js: true do
    scenario 'edit his question' do
      sign_in(author)

      visit question_path(question)

      click_on 'Edit question'

      within '.questions' do
        fill_in 'Your question title', with: 'edited question title'
        fill_in 'Your question body', with: 'edited question body'
        click_on 'Save'

        # save_and_open_page
        expect(page).to_not have_content question.title
        expect(page).to_not have_content question.body
        expect(page).to have_content 'edited question title'
        expect(page).to have_content 'edited question body'
        expect(page).to_not have_selector 'textarea'
      end
    end
  end
end