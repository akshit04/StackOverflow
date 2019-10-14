module RelationshipModule
	class RelationshipManager

		def initialize(relationship)
			self.relationship = relationship
		end

		def self.create(current_user, user)
			current_user.follow(user)
			respond_to do |format|
				format.html redirect_to user
				format.js
			end
		end

		def self.destroy(current_user, user)
			current_user.unfollow(user)
			respond_to do |format|
				format.html redirect_to @user
				format.js
			end			
		end

		private

		attr_accessor :relationship
	end
end