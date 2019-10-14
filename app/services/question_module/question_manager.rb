module QuestionModule
	class QuestionManager
		def initialize(question)
			self.question = question
		end

		def self.create(params, user)
			ActiveRecord::Base.transaction do
				# question = Question.new
				# question.assign_attributes(params)
				question = user.questions.create!(params)
				question
			end
		end

		private

		attr_accessor :question
	end
end