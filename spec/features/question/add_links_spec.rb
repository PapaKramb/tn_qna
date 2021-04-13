require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info to my answer
  As an answer author
  I'd like to be able add to links
} do

  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/PapaKramb/e8943bcca0e3c40c399d6656a19c522e' }

  scenario 'User adds links when asks answer' do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Ask'

    expect(page).to have_link 'My gist', href: gist_url
  end
end
