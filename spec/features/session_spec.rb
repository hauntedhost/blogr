require 'rails_helper'

RSpec.feature 'User sessions' do
  given(:password) { '12345678' }
  given(:user) { create(:user, password: password) }

  scenario 'login a user' do
    sign_in(user, password)
    expect(current_path).to eq(root_path)
    expect(page).to have_content(user.email)
    # save_and_open_page
  end

  scenario 'logout a user' do
    sign_in(user, password)
    click_link 'Logout'
    expect(page).not_to have_content(user.email)
  end
end
