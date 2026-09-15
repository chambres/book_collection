require "rails_helper"

RSpec.describe "Books", type: :request do
  it "adds a book and shows a flash message on the list" do
    expect { post books_path, params: { book: { title: "Dune" } } }
      .to change(Book, :count).by(1)
    expect(response).to redirect_to(books_path)
    follow_redirect!
    expect(response.body).to include("Dune", "Book added.")
  end

  it "shows errors without saving a blank title" do
    expect { post books_path, params: { book: { title: "" } } }
      .not_to change(Book, :count)
    expect(response).to have_http_status(422)
    expect(response.body).to include("Please fix the errors below.")
    expect(response.body).to match(/Title can(?:&#39;|')t be blank/)
  end

  it "shows the list, new form, details, edit and delete pages" do
    book = Book.create!(title: "Dune")
    [books_path, new_book_path, book_path(book), edit_book_path(book), delete_book_path(book)].each do |path|
      get path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include('href="/"')
    end
    expect(Book.exists?(book.id)).to be(true)
  end

  it "updates a title and returns to the list with a flash message" do
    book = Book.create!(title: "Dune")
    patch book_path(book), params: { book: { title: "Dune Messiah" } }
    expect(book.reload.title).to eq("Dune Messiah")
    expect(response).to redirect_to(books_path)
    follow_redirect!
    expect(response.body).to include("Book updated.")
  end

  it "deletes a book and shows confirmation on the list" do
    book = Book.create!(title: "Dune")
    expect { delete book_path(book) }.to change(Book, :count).by(-1)
    expect(response).to redirect_to(books_path)
    follow_redirect!
    expect(response.body).to include("Book deleted.")
  end
end
