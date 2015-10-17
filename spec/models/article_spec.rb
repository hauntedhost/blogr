# == Schema Information
#
# Table name: articles
#
#  id         :integer          not null, primary key
#  author_id  :string
#  title      :string
#  body       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Article, type: :model do
  let(:article) { build(:article) }

  it 'has a valid factory' do
    expect(article).to be_valid
  end

  describe 'validations' do
    it 'is invalid without an author' do
      expect(build(:article, author: nil)).not_to be_valid
    end

    it 'is invalid without a title' do
      expect(build(:article, title: nil)).not_to be_valid
    end

    it 'is invalid without a body' do
      expect(build(:article, body: nil)).not_to be_valid
    end
  end
end
