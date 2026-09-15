require "rails_helper"

RSpec.describe "Seeded test database", type: :request do
  it "loads five test records, keeps seeding idempotent, and displays them" do
    expect(Rails.env).to eq("test")
    load Rails.root.join("db/seeds.rb")
    expect(Book.where("title LIKE ?", "[test] %").count).to eq(5)
    expect(Book.find_by!(title: "[test] Dune").author).to eq("Frank Herbert")
    expect { load Rails.root.join("db/seeds.rb") }.not_to change(Book, :count)
    get books_path
    expect(response).to have_http_status(:ok)
    expect(response.body).to include("[test] Dune", "[test] The Hobbit")
    expect(response.body).not_to include("[development]", "[production]")
  end
end
