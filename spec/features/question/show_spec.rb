require 'rails_helper'

feature 'User can show question and answers' do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:questions) { create_list(:answer, 3, question: question, user: user) }

  scenario 'show question and answers' do
    visit question_path(question)

    # save_and_open_page
    expect(page).to have_content question.title
    expect(page).to have_content question.body
    question.answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end
end