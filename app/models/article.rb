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

class Article < ActiveRecord::Base
  belongs_to :author, class_name: 'User'

  validates_presence_of :author, :title, :body
end
