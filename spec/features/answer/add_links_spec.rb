require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As an question author
  I'd like to be able add to links
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given(:gist_url) { 'https://gist.github.com/PapaKramb/e8943bcca0e3c40c399d6656a19c522e' }

  scenario 'User adds links when asks question', js: true do
    sign_in(user)

    visit question_path(question) 

    fill_in 'Body', with: 'answer answer answer'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Create answer'

    within '.answers' do
      expect(page).to have_link 'My gist', href: gist_url
    end 
  end
end
