require 'rails_helper'

feature 'User can create answer' do
  given(:user) { create(:user) }

  scenario 'answers the question' do
    visit question_path(@question)
    fill_in 'Body', with: 'answer answer answer'
    click_on 'Create answer'

    expect(page).to have_content 'Your answer successfully created.'
    expect(page).to have_content 'Test answert'
  end

  scenario 'answers the question with errors'
end
