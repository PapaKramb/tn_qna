require 'rails_helper'

feature 'User can create answer' do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'answers the question' do
    sign_in(user)
    visit question_path(question)
    fill_in 'Body', with: 'answer answer answer'
    click_on 'Create answer'

    expect(page).to have_content 'Your answer successfully created.'
    expect(page).to have_content 'Body'
  end

  scenario 'answers the question with errors'
end
