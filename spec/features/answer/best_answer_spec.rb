require 'rails_helper'

feature 'Author can choose the best answer' do
  given!(:user) { create(:user) }
  given!(:author) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given!(:answer) { create(:answer, question: question, user: author) }
  given!(:answers) { create_list(:answer, 5, question: question, user: author) }

  describe 'Authenticated user', js: true do
    scenario 'author can choose the best answer' do
      sign_in(author)
      visit question_path(question)

      within "div#answer_#{answer.id}" do
        #save_and_open_page
        expect(page).to have_link 'Choose as the best answer'

        click_on 'Choose as the best answer'
  
        expect(page).to have_content 'Best answer'
        expect(page).to_not have_link 'Choose as the best answer'
      end
    end

    scenario 'user not can choose the best answer' do
      sign_in(user)
      visit question_path(question)

      expect(page).to_not have_link 'Choose as the best answer'
    end
  end

  scenario 'unauthenticated user not can choose the best answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Choose as the best answer'
  end

end