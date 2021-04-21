require 'rails_helper'

feature 'User can add rewards to question' do
  given(:user) { create(:user) }
  given(:image_url) { "https://www.google.com/url?sa=i&url=https%3A%2F%2Fru.depositphotos.com%2Fvector-images%2F%25D0%25BA%25D1%2583%25D0%25B1%25D0%25BE%25D0%25BA-%25D0%25BF%25D0%25BE%25D0%25B1%25D0%25B5%25D0%25B4%25D0%25B8%25D1%2582%25D0%25B5%25D0%25BB%25D1%258F-%25D0%25B8%25D0%25BA%25D0%25BE%25D0%25BD%25D0%25BA%25D0%25B0.html&psig=AOvVaw3vBbYLRsqzDMebAWPiTgS8&ust=1618999577011000&source=images&cd=vfe&ved=0CAIQjRxqFwoTCICKzJ7JjPACFQAAAAAdAAAAABAD" }

  scenario 'Author adds reward when asks a question', js: true do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    within '#reward' do
      fill_in 'Reward Title', with: 'Test reward'
      fill_in 'Reward Image', with: image_url
    end

    click_on 'Ask'

    expect(page).to have_css("img[src*='#{image_url}']")
  end
end