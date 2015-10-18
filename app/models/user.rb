# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  first_name      :string
#  last_name       :string
#  email           :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  role            :integer          default(0), not null
#  session_key     :string
#  password_digest :string
#

class User < ActiveRecord::Base
  has_secure_password

  enum role: { member: 0, admin: 1, editor: 2 }

  has_many :articles, foreign_key: :author_id

  validates_presence_of :first_name, :last_name, :email, :password_digest
  validates_length_of :password_digest, within: 8..64
  validates_uniqueness_of :email

  scope :by_letter, ->(letter) {
    where('last_name LIKE ?', "#{letter}%").order(:last_name)
  }

  def correct_password?(password)
    BCrypt::Password.new(self.password_digest) == password
  end

  def name
    [first_name, last_name].join(' ')
  end

  def random_session_key
    SecureRandom.hex(24)
  end

  def destroy_session_key!
    update_attributes(session_key: nil)
  end

  def reset_session_key!
    new_session_key = random_session_key
    while User.find_by_session_key(new_session_key)
      new_session_key = random_session_key
    end
    update_attributes(session_key: new_session_key)
  end
end
