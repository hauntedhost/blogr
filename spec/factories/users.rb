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
    first_name "MyString"
    last_name "MyString"
    sequence(:email) { |n| "user#{n}@example.com" }

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
