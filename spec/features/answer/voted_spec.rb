require 'rails_helper'

feature 'User can vote for a answer', %q{
  In order to show that answer is good
  As an authenticated user
  I'd like to be able to vote
} do

  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given!(:answer) { create(:answer, question: question, user: author) }

  describe 'User is not an author of question', js: true do

    background do
      sign_in (user)
      visit question_path(question)
    end

    scenario 'votes up for question' do

      within "#answer_#{answer.id}" do
        click_on 'Like'
        within '.rating' do
          expect(page).to have_content '1'
        end
      end
    end

    scenario 'votes down for question' do

      within "#answer_#{answer.id}" do
        click_on 'Dislike'
        within '.rating' do
          expect(page).to have_content '-1'
        end
      end
    end

    scenario 'votes down for question' do

      within "#answer_#{answer.id}" do
        click_on 'Like'
        click_on 'Delete vote'
        within '.rating' do
          expect(page).to have_content '0'
        end
      end
    end
  end

  describe 'User is an author of question', js: true do

    scenario 'votes for question' do

      sign_in (author)
      visit question_path(question)
      within "#answer_#{answer.id}" do
        expect(page).to_not have_content 'Like|Delete'
        expect(page).to_not have_content 'Delete vote'
      end
    end
  end

  describe 'User is unauthenticate of question', js: true do

    scenario 'votes for question' do

      visit question_path(question)
      within "#answer_#{answer.id}" do
        expect(page).to_not have_content 'Like|Delete'
        expect(page).to_not have_content 'Delete vote'
      end
    end
  end
end