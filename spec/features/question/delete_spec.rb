require 'rails_helper'

feature 'User can delete his question' do
  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given(:question) { create(:question, user: author) }

  describe 'Authenticated user', js: true do
    scenario 'author delete question' do
      sign_in(author)
      visit question_path(question)
      
      expect(page).to have_content question.title
      expect(page).to have_content question.body
      click_on 'Delete question'

      expect(page).not_to have_content question.title 
      expect(page).not_to have_content question.body
      expect(page).to have_content 'Your question was successfully deleted!'
    end

    scenario 'delete question with attached file' do
      sign_in(author)

      visit question_path(question)

      click_on 'Edit question'
      
      within '.questions' do
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'
      end
      visit question_path(question)

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
      # save_and_open_page
      within "#file_#{question.files.first.id}" do
        click_on 'Delete file'
      end

      expect(page).to_not have_link 'rails_helper.rb'
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