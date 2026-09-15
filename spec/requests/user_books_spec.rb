require "rails_helper"

RSpec.describe "User books", type: :request do
  it "uses User Books as Home and links to both indexes" do
    get root_path
    expect(response).to have_http_status(:ok)
    expect(response.body).to include("User Books", 'href="/books"', 'href="/users"', 'href="/user_books/new"')
  end

  it "uses names in dropdowns and saves, edits and removes an assignment" do
    user = User.create!(username: "rahul")
    first = Book.create!(title: "Dune")
    second = Book.create!(title: "The Hobbit")
    get new_user_book_path
    page = Nokogiri::HTML(response.body)
    expect(page.at_css('#user_book_user_id').text).to include("rahul")
    expect(page.at_css('#user_book_book_id').text).to include("Dune", "The Hobbit")

    expect { post user_books_path, params: { user_book: { user_id: user.id, book_id: first.id } } }
      .to change(UserBook, :count).by(1)
    expect(response).to redirect_to(user_books_path)
    follow_redirect!
    expect(response.body).to include("rahul", "Dune", "Book assigned.")

    link = UserBook.last
    get user_book_path(link)
    expect(response.body).to include("rahul", "Dune")
    get edit_user_book_path(link)
    expect(response).to have_http_status(:ok)
    patch user_book_path(link), params: { user_book: { book_id: second.id } }
    expect(link.reload.book).to eq(second)
    expect { delete user_book_path(link) }
      .to change(UserBook, :count).by(-1).and change(Book, :count).by(0)
    expect(User.exists?(user.id)).to be(true)
    expect(Book.where(id: [ first.id, second.id ]).count).to eq(2)
  end

  it "shows errors for empty selections" do
    expect { post user_books_path, params: { user_book: { user_id: "", book_id: "" } } }
      .not_to change(UserBook, :count)
    expect(response).to have_http_status(422)
    expect(response.body).to include("User must exist", "Book must exist")
  end

  it "creates, edits and deletes a user" do
    post users_path, params: { user: { username: "rahul" } }
    expect(response).to redirect_to(users_path)
    user = User.last
    get user_path(user)
    expect(response.body).to include("rahul")
    get edit_user_path(user)
    expect(response).to have_http_status(:ok)
    patch user_path(user), params: { user: { username: "rahul_s" } }
    expect(user.reload.username).to eq("rahul_s")
    book = Book.create!(title: "Dune")
    UserBook.create!(user: user, book: book)
    expect { delete user_path(user) }.to change(User, :count).by(-1)
    expect(UserBook.count).to eq(0)
    expect(Book.exists?(book.id)).to be(true)
  end
end
