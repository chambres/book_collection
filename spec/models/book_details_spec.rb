require "rails_helper"

RSpec.describe Book, type: :model do
  it "stores the author" do
    book = Book.create!(title: "Dune", author: "Frank Herbert")
    expect(book.reload.author).to eq("Frank Herbert")
  end

  it "stores a numeric price" do
    book = Book.create!(title: "Dune", price: "12.50")
    expect(book.reload.price).to eq(BigDecimal("12.50"))
  end

  it "rejects a nonnumeric price" do
    book = Book.new(title: "Dune", price: "abc")
    expect(book).not_to be_valid
    expect(book.errors[:price]).to include("is not a number")
  end

  it "stores a published date" do
    book = Book.create!(title: "Dune", published_date: "1965-08-01")
    expect(book.reload.published_date).to eq(Date.new(1965, 8, 1))
  end
end
