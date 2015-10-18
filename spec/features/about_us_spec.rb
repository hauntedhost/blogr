require 'rails_helper'

RSpec.feature 'About Us' do
  scenario 'toggles display of about us', js: true do
    visit root_path
    expect(page).not_to have_content('We are your friends')
    click_link 'About Us'
    expect(page).to have_content('We are your friends')
    click_link 'About Us'
    expect(page).not_to have_content('We are your friends')
  end
end