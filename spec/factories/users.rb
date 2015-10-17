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

FactoryGirl.define do
  factory :user do
    first_name "MyString"
    last_name "MyString"
    sequence(:email) { |n| "user#{n}@example.com" }
  end
end
