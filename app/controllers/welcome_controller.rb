class WelcomeController < ApplicationController
  def index
  	if logged_in?
  		@question = current_user.questions.new
  		@feed_items = current_user.feed
  	end
  end
end