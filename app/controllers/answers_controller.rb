class AnswersController < ApplicationController
	def new
		@user = User.find(params[:user_id])
		@question = Question.find(params[:question_id])
		@answer = Answer.new
	end

	def create
		# @question = Question.find_by(id: params[:question_id])
		# @answer = @question.answers.create(answer_params)
		# render 'answers/index'

		@question = Question.find_by(id: params[:question_id])
		answer = AnswerModule::AnswerManager.create(answer_params, @question)
		# debugger
		render 'answers/index'
	end

	def index
		@question = Question.find(params[:question_id])
	end

	private

	def answer_params
		params.require(:answer).permit(:answer)
	end
end