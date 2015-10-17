# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  first_name :string
#  last_name  :string
#  email      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    let(:user) { build(:user) }

    it 'has a valid factory' do
      expect(user).to be_valid
    end

    it 'is invalid without a first_name' do
      user = build(:user, first_name: nil)
      expect(user).not_to be_valid
      expect(user.errors[:first_name]).to include("can't be blank")
    end

    it 'is invalid without a last_name' do
      user = build(:user, last_name: nil)
      expect(user).not_to be_valid
      expect(user.errors[:last_name]).to include("can't be blank")
    end

    it 'is invalid without an email' do
      user = build(:user, email: nil)
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("can't be blank")
    end

    it 'is invalid with a duplicate email' do
      user.save!
      user2 = build(:user, email: user.email)
      expect(user2).not_to be_valid
      expect(user2.errors[:email]).to include('has already been taken')
    end
  end

  describe 'scopes' do
    describe '.by_letter' do
      let!(:jameson) { create(:user, last_name: 'Jameson') }
      let!(:johnson) { create(:user, last_name: 'Johnson') }
      let!(:kelly) { create(:user, last_name: 'Kelly') }
      let(:users) { User.by_letter('J') }

      it 'returns users where last_name starts with letter' do
        expect(users).to eq([jameson, johnson])
      end

      it 'omits users where last_name does not start with letter' do
        expect(users).not_to include(kelly)
      end
    end
  end

  describe '#name' do
    it "returns a user's full name" do
      user = build(:user, first_name: 'Sean', last_name: 'Omlor')
      expect(user.name).to eq('Sean Omlor')
    end
  end
end
