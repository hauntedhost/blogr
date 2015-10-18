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
    it { is_expected.to validate_presence_of(:author) }
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:body) }
  end
end
