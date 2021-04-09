require 'rails_helper'

feature 'User can create answer' do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)

      visit question_path(question) 
    end

    scenario 'answers the question' do
      fill_in 'Body', with: 'answer answer answer'
      click_on 'Create answer'
      
      expect(current_path).to eq question_path(question)
      within '.answers' do
        expect(page).to have_content 'answer answer answer'
      end
    end

    scenario 'answers the question with errors' do
      click_on 'Create answer'

      expect(page).to have_content "Body can't be blank"
    end

    scenario 'create answer with attached file' do
      fill_in 'Body', with: 'answer answer answer'

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Create answer'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  scenario 'Unauthenticated user tries to answer' do
    visit question_path(question)
    click_on 'Create answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

end
