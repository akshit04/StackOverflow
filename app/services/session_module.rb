# module SessionModule

# 	def log_in(user)
# 		session[:user_id] = user.id
# 	end

# 	def remember(user)   # log_in for cookies, not for sessions
# 		user.remember          # saving remember digest in dB
# 		cookies.permanent.signed[:user_id] = user.id          # saving user_id attribute of cookie
# 		cookies.permanent[:remember_token] = user.remember_token           # saving remember_token attribute of cookie
# 		# remember_token is attr_accessor in user models
# 	end

# 	def forget(user)      # logging out for cookies, not for sessions
# 		user.forget
# 		cookies.delete(:user_id)
# 		cookies.delete(:remember_token)
# 	end

# 	def current_user?(user)
# 		user == current_user
# 	end

# 	def current_user
# 		if (user_id = session[:user_id])
# 			@current_user ||= User.find_by(id: user_id)
# 		elsif (user_id = cookies.signed[:user_id])
# 			user = User.find_by(id: user_id)
# 			if user && user.authenticated?(cookies[:remember_token])
# 				log_in user
# 				@current_user = user
# 			end
# 		end
# 	end

# 	def logged_in?
#     !current_user.nil?
# 	end

# 	def log_out       
# 		forget(current_user)      # logging out for cookies, not for sessions
# 		session.delete(:user_id)     # logging out for sessions, not cookies
# 		@current_user = nil
# 	end

# end