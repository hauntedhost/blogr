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

class User < ActiveRecord::Base
  validates_presence_of :first_name, :last_name, :email
  validates_uniqueness_of :email

  scope :by_letter, ->(letter) {
    where('last_name LIKE ?', "#{letter}%").order(:last_name)
  }

  def name
    [first_name, last_name].join(' ')
  end
end
