class BookCommentsController < ApplicationController
 before_action :authenticate_user!
  def create
    @book = Book.find(params[:book_id])
    @book_comment = current_user.book_comments.new(book_comment_params)
    @book_comment.book_id = @book.id
    if @book_comment.save
      flash[:success] = "Comment was successfully created."
      redirect_to book_path(@book)
    else
      @book = Book.find(params[:book_id])
      @books = Book.new
      render '/books/show'
  end
end

  def destroy
    @book = Book.find(params[:book_id])
    @book_comment = current_user.book_comments.find_by(book_id: @book.id)
    if @book_comment.user != current_user
      redirect_back(fallback_location: root_path)
    end
    @book_comment.destroy
    redirect_to book_path(@book)
  end

  private
  def book_comment_params
    params.require(:book_comment).permit(:comment)
  end
end