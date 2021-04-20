require 'rails_helper'

feature 'User can delete links to question' do
  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given!(:link) { create(:link, linkable: question) }

  describe 'Authenticated user', js: true do
    scenario 'author can delete links to their questions', js: true do
      sign_in(author)
      visit question_path(question)

      expect(page).to have_link link.name

      click_on 'Delete link'

      expect(page).to_not have_link link.name
    end

    scenario 'not author can delete links to their questions', js: true do
      sign_in(user)
      visit question_path(question)

      expect(page).to_not have_link 'Delete link'
    end
  end

  scenario 'Unauthenticated user tries delete link' do
    visit question_path(question)

    expect(page).to_not have_link 'Delete link'
  end

end