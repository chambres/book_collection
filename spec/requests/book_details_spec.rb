require "rails_helper"

RSpec.describe "Book details", type: :request do
  it "accepts and displays the author" do
    post books_path, params: { book: { title: "Dune", author: "Frank Herbert" } }
    expect(response).to redirect_to(books_path)
    book = Book.last
    expect(book.author).to eq("Frank Herbert")
    get book_path(book)
    expect(response.body).to include("Frank Herbert")
  end

  it "accepts and displays the price" do
    post books_path, params: { book: { title: "Dune", price: "12.50" } }
    expect(response).to redirect_to(books_path)
    book = Book.last
    expect(book.price).to eq(BigDecimal("12.50"))
    get book_path(book)
    expect(response.body).to include("12.50")
  end

  it "accepts and displays a date from dropdowns" do
    post books_path, params: { book: {
      title: "Dune", "published_date(1i)" => "1965",
      "published_date(2i)" => "8", "published_date(3i)" => "1"
    } }
    expect(response).to redirect_to(books_path)
    book = Book.last
    expect(book.published_date).to eq(Date.new(1965, 8, 1))
    get book_path(book)
    expect(response.body).to include("1965-08-01")
  end

  it "provides three published-date dropdowns" do
    get new_book_path
    page = Nokogiri::HTML(response.body)
    expect(page.css('select[name^="book[published_date"]').length).to eq(3)
  end
end
