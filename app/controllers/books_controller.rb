class BooksController < ApplicationController
	before_action :authenticate_user!

  def show
		@book = Book.find(params[:id])

		@user = @book.user
		# binding.pry
  end

  def index
		@books = Book.all #一覧表示するためにBookモデルの情報を全てくださいのall
		@book = Book.new
  end

	def create
		@book = Book.new(book_params) #Bookモデルのテーブルを使用しているのでbookコントローラで保存する。
		@book.user_id = current_user.id
  	if @book.save #入力されたデータをdbに保存する。
  		redirect_to @book, notice: "successfully created book!"#保存された場合の移動先を指定。
  	else
			@books = Book.all
			# @book = Book.new
			# ↑ create1段目で@bookを定義しており、そこにエラーのデータが入っているのに、再度@book = Book.newを定義し打ち消してしまっていた
			@user = current_user.id
			render :index
  	end
  end

  def edit
		@book = Book.find(params[:id])
		if @book.user == current_user
			render :edit
		else
			redirect_to books_path
		end
  end



  def update
		@book = Book.find(params[:id])
		@user = User.find(current_user.id)
  	if @book.update(book_params)
  		redirect_to @book, notice: "successfully updated book!"
  	else #if文でエラー発生時と正常時のリンク先を枝分かれにしている。
  		render :edit
  	end
  end

  def destroy
  	@book = Book.find(params[:id])
  	@book.destroy
  	redirect_to books_path, notice: "successfully delete book!"
  end

  private

  def book_params
  	params.require(:book).permit(:title, :body)
  end

end
