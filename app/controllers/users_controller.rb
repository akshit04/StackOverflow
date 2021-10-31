class UsersController < ApplicationController

	before_action :logged_in_user, only: [:show, :index]

  def new
  	@user = User.new
  end

  def index
  	@users = User.all
  end

  def create

    ##### w/o Servives #####
  	# @user = User.new(user_params)
  	# if @user.save
  	# 	log_in @user
  	# 	redirect_to @user
  	# else
  	# 	render 'new'
  	# end


    ##### w/ Services #####
    user = user_manager.create!(user_params)
    log_in user
    redirect_to user
  end

	def show
		@user = User.find(params[:id])
	end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers" 
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

	private

  def user_manager
    @user_manager ||= UserModule::UserManager
  end


	def user_params
		params.require(:user).permit(:name, :email, :password, :password_confirmation)
	end
end
