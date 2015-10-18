require 'rails_helper'

RSpec.feature 'Articles' do
  context 'as a logged in user' do
    given(:user) { create(:user) }

    background do
      sign_in(user)
    end

    scenario 'adds a new article' do
      visit articles_path
      expect(page).not_to have_content 'Rick and Morty Forever Dot Com'

      click_link 'New Article'
      expect(current_path).to eq(new_article_path)

      fill_in :article_title, with: 'Rick and Morty Forever Dot Com'
      fill_in :article_body, with: 'Lorem ipsum sit amet, consectetur adipisic elit.'
      find('input[type="submit"]').click

      expect(current_path).to eq_show_path(:article_path)
      expect(page).to have_content 'Rick and Morty Forever Dot Com'
    end
  end
end
