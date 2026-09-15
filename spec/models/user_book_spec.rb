require "rails_helper"

RSpec.describe UserBook, type: :model do
  it "lets a user have several books and a book have several users" do
    rahul = User.create!(username: "rahul")
    alex = User.create!(username: "alex")
    dune = Book.create!(title: "Dune")
    hobbit = Book.create!(title: "The Hobbit")
    UserBook.create!(user: rahul, book: dune)
    UserBook.create!(user: rahul, book: hobbit)
    UserBook.create!(user: alex, book: dune)
    expect(rahul.books).to contain_exactly(dune, hobbit)
    expect(dune.users).to contain_exactly(rahul, alex)
  end

  it "requires an existing user and book" do
    expect(UserBook.new).not_to be_valid
    expect(UserBook.new(user_id: -1, book_id: -1)).not_to be_valid
  end

  it "rejects duplicate assignments" do
    link = UserBook.create!(user: User.create!(username: "rahul"), book: Book.create!(title: "Dune"))
    expect(UserBook.new(user: link.user, book: link.book)).not_to be_valid
  end

  it "removes assignments when a book is deleted without deleting the user" do
    user = User.create!(username: "rahul")
    book = Book.create!(title: "Dune")
    UserBook.create!(user: user, book: book)
    expect { book.destroy! }.to change(UserBook, :count).by(-1)
    expect(User.exists?(user.id)).to be(true)
  end
end
