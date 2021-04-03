require 'rails_helper'

feature 'User can registration' do

  background { visit new_user_registration_path }

  scenario 'registration completed successfully' do
    fill_in 'Email', with: 'test@test.com'
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123456'
    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'user forgot to enter email' do
    click_on 'Sign up'

    expect(page).to have_content "Email can't be blank"
  end

  scenario 'user forgot to enter password' do
    fill_in 'Email', with: 'test@test.com'
    click_on 'Sign up'

    expect(page).to have_content "Password can't be blank"
  end

  scenario 'user forgot to enter password confirmation' do
    fill_in 'Email', with: 'test@test.com'
    fill_in 'Password', with: '123456'
    click_on 'Sign up'

    expect(page).to have_content "Password confirmation doesn't match Password"
  end

end