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
#  role       :integer          default(0), not null
#

FactoryGirl.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    sequence(:email) { |n| Faker::Internet.email }

    factory :member do
      role 'member'
    end

    factory :admin do
      role 'admin'
    end

    factory :editor do
      role 'editor'
    end
  end
end
