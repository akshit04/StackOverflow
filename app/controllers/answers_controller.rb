class AnswersController < ApplicationController

	before_action :logged_in_user

	def new
		@user = User.find(params[:user_id])
		@question = Question.find(params[:question_id])
		@answer = Answer.new
	end

	def create

		##### w/o Services #####
		# @question = Question.find_by(id: params[:question_id])
		# @answer = @question.answers.create(answer_params)
		# render 'answers/index'

		##### w/ Services #####
		@question = Question.find_by(id: params[:question_id])
		answer = answer_manager.create(answer_params, @question)
		render 'answers/index'
	end

	def index
		@question = Question.find(params[:question_id])
	end

	private

	def answer_manager
		@answer_manager ||= AnswerModule::AnswerManager
	end

	# def answer
	# 	@answer ||= Answer.find(params[:id])
	# end

	def answer_params
		params.require(:answer).permit(:answer)
	end
end