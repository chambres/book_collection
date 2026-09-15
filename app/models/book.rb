class Book < ApplicationRecord
  has_many :user_books, dependent: :destroy
  has_many :users, through: :user_books
  validates :title, presence: true
  validates :price, numericality: true, allow_nil: true
end
