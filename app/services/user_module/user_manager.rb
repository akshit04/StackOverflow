module UserModule
	class UserManager
		def initialize(user)
			self.user = user
		end

		def self.create!(params)
			user = User.new
			ActiveRecord::Base.transaction do
				user.assign_attributes(params)
				user.save!
			end
			user
		end

		private

		attr_accessor :user
	end
end