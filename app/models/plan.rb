class Plan < ApplicationRecord
  has_many :registrations

  validates :name, presence: true
  validates :description, presence: true
  validates :price, presence: true
end
