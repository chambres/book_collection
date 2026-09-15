class BooksController < ApplicationController
  before_action :set_book, only: %i[ show edit update delete destroy ]

  # GET /books
  def index
    @books = Book.order(:title)
  end

  # GET /books/1
  def show
  end

  # GET /books/new
  def new
    @book = Book.new
  end

  # GET /books/1/edit
  def edit
  end

  def delete
  end

  # POST /books
  def create
    @book = Book.new(book_params)

    if @book.save
      redirect_to books_path, notice: "Book added.", status: :see_other
    else
      flash.now[:alert] = "Please fix the errors below."
      render :new, status: :unprocessable_content
    end
  end

  # PATCH/PUT /books/1
  def update
    if @book.update(book_params)
      redirect_to books_path, notice: "Book updated.", status: :see_other
    else
      flash.now[:alert] = "Please fix the errors below."
      render :edit, status: :unprocessable_content
    end
  end

  # DELETE /books/1
  def destroy
    @book.destroy!
    redirect_to books_path, notice: "Book deleted.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def book_params
      params.expect(book: [ :title, :author, :price, :published_date ])
    end
end
