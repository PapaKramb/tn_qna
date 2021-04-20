require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an a author of answer
  I'd like ot be able to edit my answer
} do
  
  given!(:user) { create(:user) }
  given!(:author) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: author) }
  given(:gist_url) { 'https://gist.github.com/PapaKramb/e8943bcca0e3c40c399d6656a19c522e' }

  scenario 'Unauthenticated can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user', js: true do
    scenario 'edit his answer' do
      sign_in(author)

      visit question_path(question)

      click_on 'Edit answer'

      within '.answers' do
        fill_in 'Your answer', with: 'edited answer'
        click_on 'Save'

        # save_and_open_page
        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end
    
    scenario 'edits his answer with errors' do
      sign_in(author)

      visit question_path(question)

      click_on 'Edit'
      # save_and_open_page
      within '.answers' do
        fill_in 'Your answer', with: ''

        click_on 'Save'
        
        expect(page).to have_content "Body can't be blank"
      end
    end

    scenario "tries to edit other user's answer" do
      sign_in(user)
      visit question_path(question)

      expect(page).to_not have_link 'Edit answer'
    end

    scenario 'edit answer with attached file' do
      sign_in(author)

      visit question_path(question)

      click_on 'Edit answer'
      
      within '.answers' do
        fill_in 'Your answer', with: 'edited answer'

        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'
      end
      visit question_path(question)

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'edit answer with add links' do
      sign_in(author)

      visit question_path(question)

      click_on 'Edit answer'
      
      within '.answers' do
        fill_in 'Your answer', with: 'edited answer'

        click_on 'add link'

        within all('.nested-fields')[0] do
          fill_in 'Link name', with: 'My gist'
          fill_in 'Url', with: gist_url
        end

        click_on 'Save'
      end
      visit question_path(question)

      expect(page).to have_link 'My gist', href: gist_url
    end
  end
end
