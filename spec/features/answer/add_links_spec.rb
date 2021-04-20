require 'rails_helper'

feature 'User can add links to answer', %q{
    In order to provide additional info to my answer
    As an answer author
    I'd like to be able add to links
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given(:gist_url) { 'https://gist.github.com/PapaKramb/e8943bcca0e3c40c399d6656a19c522e' }
  given(:google_url) { 'https://google.com' }

  scenario 'User adds links when asks answer', js: true do
    sign_in(user)
    visit question_path(question) 

    fill_in 'Body', with: 'answer answer answer'

    click_on 'add link'

    within all('.nested-fields')[0] do
      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: gist_url
    end

    click_on 'add link'

    within all('.nested-fields')[1] do
      fill_in 'Link name', with: 'Google'
      fill_in 'Url', with: google_url
    end

    click_on 'Create answer'

    within '.answers' do
      # save_and_open_page
      expect(page).to have_link 'My gist', href: gist_url
      expect(page).to have_link 'Google', href: google_url
    end
  end
end
