class User < ApplicationRecord
  has_many :registrations
  has_many :registered_events, through: :registrations, source: :event
  has_many :created_events, class_name: 'Event', foreign_key: 'user_id'

  devise :database_authenticatable, :registerable, :validatable

  validates :name, presence: true
end
