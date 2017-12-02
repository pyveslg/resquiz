class Quiz < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :answers, through: :questions
  has_many :options, through: :questions

  ## Instance Method to check if the quiz has been played or not. Return false if not played.

  def played?
    !self.answers.empty?
  end

  def finished?
    self.answers.length == self.questions.length ? true : false
  end

  def result
    sum = 0
    self.answers.each do |answer|
      sum += answer.score
    end
    total = sum.fdiv(self.answers.size) * 100
    return total.ceil
  end
end
