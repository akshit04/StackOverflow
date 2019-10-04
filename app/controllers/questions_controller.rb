class QuestionsController < ApplicationController

	def index
		@user = User.find(params[:user_id])
	end

	def show
		@question = Question.find(params[:id])
	end

	def create
		@user = User.find(params[:user_id])
		@question = current_user.questions.create(question_params)
		render 'questions/index'
	end

	def destroy
		@user = User.find(params[:user_id])
		@question = @user.questions.find(params[:id])
		@question.destroy
		render 'questions/index'
	end

	private

	def question_params
		params.require(:question).permit(:question)
	end

end
