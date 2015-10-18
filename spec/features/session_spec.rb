require 'rails_helper'

RSpec.feature 'User sessions' do
  given(:user) { create(:user) }

  background do
    sign_in(user)
  end

  scenario 'login a user' do
    expect(current_path).to eq(root_path)
    expect(page).to have_content(user.email)
    # save_and_open_page
  end

  scenario 'logout a user' do
    click_link 'Logout'
    expect(page).not_to have_content(user.email)
  end
end
