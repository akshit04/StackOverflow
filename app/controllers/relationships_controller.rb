class RelationshipsController < ApplicationController
	before_action :logged_in_user

	def create
		user = User.find(params[:followed_id])
		current_user.follow(user)
		# respond_to is more like an if-then-else statement than a series of sequential lines, i.e. only one of them will be executed
		respond_to do |format|
			format.html redirect_to @user
			format.js
		end
	end

	def destroy
		user = Relationship.find(params[:id]).followed
		current_user.unfollow(user)
		respond_to do |format|
			format.html redirect_to @user
			format.js
		end
	end
end
