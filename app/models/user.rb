class User < ApplicationRecord

	before_save { self.email = email.downcase }
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

	has_secure_password

	validates :name, presence: true, length: {maximum: 50}
	validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }, uniqueness: {case_sensitive: false}
	validates :password, presence: true, length: { minimum: 6 }, allow_blank: true  # don't worry about new user not adding pswds., it will be handeled by has_secure_password

	has_many :questions, dependent: :destroy
	has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
	has_many :following, through: :active_relationships, source: :followed
	has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
	has_many :followers, through: :passive_relationships, source: :follower

	def self.new_token
		SecureRandom.urlsafe_base64
	end

	def self.digest(string)
		cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :  BCrypt::Engine.cost
		BCrypt::Password.create(string, cost: cost)
	end

	attr_accessor :remember_token

	def remember
		self.remember_token = User.new_token
		update_attribute(:remember_digest, User.digest(remember_token))
	end

	def authenticated?(remember_token)
		return false if remember_digest.nil?
		BCrypt::Password.new(remember_digest).is_password?(remember_token)
	end

	def forget
		update_attribute(:remember_digest, nil)
	end

	def feed
		following_ids = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"
		Question.where("user_id IN (#{following_ids}) OR user_id = :user_id", user_id: id)   
		# pg. 667 start reading

		# EQUIVALENT SQL
		# SELECT * FROM questions WHERE user_id IN 
		# (SELECT followed_id FROM relationships WHERE  follower_id = 1) OR user_id = 1


		# Question.where("user_id = ?", id)   # return all questions for a user
	end

	def follow(other_user)
		active_relationships.create(followed_id: other_user.id)
	end

	def unfollow(other_user)
		active_relationships.find_by(followed_id: other_user.id).destroy
	end

	def following?(other_user)
		following.include?(other_user)
	end
end