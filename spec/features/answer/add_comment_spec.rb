require 'rails_helper'
feature 'User can add comments to answer' do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given!(:answer) { create(:answer, user: author, question: question) }

  describe 'User adds comment', js: true do
    scenario 'with valid params' do
      sign_in(user)
      visit question_path(question)
      
      within ".answers" do
        fill_in 'Your comment', with: 'My comment'
        click_on "Comment"

        within '.comments' do
          expect(page).to have_content "My comment"
        end
      end
    end

    scenario 'with invalid params' do
      sign_in(user)
      visit question_path(question)

      within ".answers" do
        fill_in 'Your comment', with: ''
        click_on "Comment"

        expect(page).to have_content "error(s)"
      end
    end
  end

  scenario 'Unauthenticated user tries to create comment',js: true do
    visit question_path(question)

    within ".answers" do
      expect(page).to_not have_field "Your comment"
      expect(page).to_not have_button "Comment"
    end
  end


  describe 'multiple sessions', js: true do
    scenario "comment appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within '.answers' do
          fill_in 'Your comment', with: "TestComment"
          click_on 'Comment'

          within '.comments' do
            expect(page).to have_content "TestComment"
          end
        end
      end

      Capybara.using_session('guest') do
        expect(page).to have_content "TestComment"
      end
    end
  end
end