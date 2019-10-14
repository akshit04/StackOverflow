module AnswerModule
	class AnswerManager
		def initialize(answer)
			self.answer = answer
		end

		def self.create(params, question)
			ActiveRecord::Base.transaction do
				# answer = Answer.new
				# answer.assign_attributes(params)
				answer = question.answers.create!(params)
				answer
			end
		end

		private

		attr_accessor :answer
	end
end