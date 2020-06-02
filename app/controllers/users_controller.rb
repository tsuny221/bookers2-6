class UsersController < ApplicationController
      before_action :authenticate_user!
	    before_action :baria_user,{only: [:edit,:update]}

  def show
  	@user = User.find(params[:id])
  	@books = @user.books
  	@book = Book.new #new bookの新規投稿で必要（保存処理はbookコントローラー側で実施）
  end

  def index
  	@users = User.all #一覧表示するためにUserモデルのデータを全て変数に入れて取り出す。
  	@book = Book.new #new bookの新規投稿で必要（保存処理はbookコントローラー側で実施）
  end
  def edit
  	@user = User.find(params[:id])
  end

  def update
  	@user = User.find(params[:id])
  	if @user.update(user_params)
  		redirect_to user_path(@user), notice: "successfully updated user!"
  	else
  		render :edit
  	end
  end

  def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.page(params[:page]).reverse_order
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.page(params[:page]).reverse_order
    render 'show_follow'
  end
  def search
    @user_or_book = params[:option]
    @how_search = params[:choice]
    if @user_or_book == "1"
       @users = User.search(params[:search], @user_or_book, @how_search)
    else
      @books = Book.search(params[:search], @user_or_book, @how_search)
    end
  end

  private
  def user_params
  	params.require(:user).permit(:name, :introduction, :profile_image, :search)
  end

  #url直接防止　メソッドを自己定義してbefore_actionで発動。
   def baria_user
    @user = User.find(params[:id])
  	if @user != current_user
  		redirect_to user_path(current_user)
  	end
   end

end
