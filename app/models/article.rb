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

require 'csv'

class Article < ActiveRecord::Base
  belongs_to :author, class_name: 'User'

  validates_presence_of :author, :title, :body

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      all.map do |article|
        csv << article.attributes.values_at(*column_names)
      end
    end
  end
end
