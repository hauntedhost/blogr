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

FactoryGirl.define do
  factory :article do
    association :author, factory: :user
    title { Faker::Lorem.sentence.titleize }
    body { Faker::Lorem.paragraph }
  end
end
