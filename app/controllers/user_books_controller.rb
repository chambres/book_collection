class UserBooksController < ApplicationController
  before_action :set_user_book, only: %i[ show edit update destroy ]
  before_action :form_options, only: %i[ new edit create update ]

  # GET /user_books
  def index
    @user_books = UserBook.includes(:user, :book).order(:id)
  end

  # GET /user_books/1
  def show
  end

  # GET /user_books/new
  def new
    @user_book = UserBook.new
  end

  # GET /user_books/1/edit
  def edit
  end

  # POST /user_books
  def create
    @user_book = UserBook.new(user_book_params)

    if @user_book.save
      redirect_to user_books_path, notice: "Book assigned.", status: :see_other
    else
      render :new, status: :unprocessable_content
    end
  end

  # PATCH/PUT /user_books/1
  def update
    if @user_book.update(user_book_params)
      redirect_to user_books_path, notice: "Assignment updated.", status: :see_other
    else
      render :edit, status: :unprocessable_content
    end
  end

  # DELETE /user_books/1
  def destroy
    @user_book.destroy!
    redirect_to user_books_path, notice: "Assignment removed.", status: :see_other
  end

  private
    def form_options
      @users = User.order(:username)
      @books = Book.order(:title)
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_user_book
      @user_book = UserBook.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def user_book_params
      params.expect(user_book: [ :user_id, :book_id ])
    end
end
