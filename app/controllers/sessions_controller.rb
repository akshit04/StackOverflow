class SessionsController < ApplicationController

	def new
	end

	def create  # for log_in
		user = User.find_by(email: params[:session][:email].downcase)
		if user && user.authenticate(params[:session][:password])
			log_in user
			remember user   # storing remember digest in dB and storing cookie attributes in browser
			redirect_to user
		else
			render 'new'
		end
	end

	def destroy
		log_out if logged_in?
		redirect_to root_url
	end

end