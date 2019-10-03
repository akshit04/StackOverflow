class QuestionsController < ApplicationController

	def index
		@user = User.find(params[:user_id])
	end

	def show
		@question = Question.find(params[:id])
	end

	def create
		@question = current_user.questions.create(question_params)
		redirect_to @user
	end

	def destroy
		@user = User.find(params[:user_id])
		@question = @user.questions.find(params[:id])
		@question.destroy
	end

	private

	def question_params
		params.require(:question).permit(:question, :body)
	end

end
