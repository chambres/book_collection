class Book < ApplicationRecord
  validates :title, presence: true
  validates :price, numericality: true, allow_nil: true
end
