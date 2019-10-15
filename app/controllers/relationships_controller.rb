class RelationshipsController < ApplicationController
	before_action :logged_in_user

	def create
		user = User.find(params[:followed_id])
		
		##### w/o Services #####
		# current_user.follow(user)
		# respond_to is more like an if-then-else statement than a series of sequential lines, i.e. only one of them will be executed
		# respond_to do |format|
		# 	format.html redirect_to @user
		# 	format.js
		# end


		##### w/ Services #####
		relationship_manager.create(current_user, user)
	end

	def destroy
		user = Relationship.find(params[:id]).followed

		##### w/o Services #####
		# current_user.unfollow(user)
		# respond_to do |format|
		# 	format.html redirect_to @user
		# 	format.js
		# end


		##### w/ Services #####
		relationship_manager.destroy(current_user, user)
	end

	private

	def relationship_manager
		@relationship_manager ||=  RelationshipModule::RelationshipManager
	end

	# def relationship
	# 	@relationship ||= Relationship.find(params[:id])
	# end
end