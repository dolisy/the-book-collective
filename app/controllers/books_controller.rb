class BooksController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :index, :show ]

  def index
    @books = Book.search(params[:term])

    @hash = Gmaps4rails.build_markers(@books) do |book, marker|
    marker.lat book.library.latitude
    marker.lng book.library.longitude
    # marker.infowindow render_to_string(partial: "/flats/map_box", locals: { flat: flat })
    end
  end

  def show
    @book = Book.find(params[:id])
  end

  def new
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    @book.save

    redirect_to book_path(@book)
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    @book.update(book_params)

    redirect_to book_path(@book)
  end

  def book_params
    params.require(:book).permit(:title, :genre, :author, :publisher, :library_id, :term, :photo)
  end
end
