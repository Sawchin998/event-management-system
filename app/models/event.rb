class Event < ApplicationRecord
  has_many :registrations
  has_many :users, through: :registrations, dependent: :destroy
  belongs_to :creator, class_name: 'User', foreign_key: 'user_id'

  enum :category, { sports: 0, business: 1, education: 2, social: 3, cultural: 4, others: 5 }
  validates :category, presence: true
  validates :title, presence: true
  validates :date, presence: true
  validates :location, presence: true

  scope :search_by_title, ->(title) { where("title LIKE ?", "%#{title}%") }
end
