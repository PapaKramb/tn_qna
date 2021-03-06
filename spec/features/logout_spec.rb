require 'rails_helper'

feature 'User can logout' do
  given(:user) { create(:user) }

  scenario 'user logout' do
    sign_in(user)
    click_on 'Logout'

    expect(page).to have_content 'Signed out successfully.'
  end
end
