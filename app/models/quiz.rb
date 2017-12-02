class Quiz < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :answers, through: :questions
  has_many :options, through: :questions

  ## Instance Method to check if the quiz has been played or not. Return false if not played.

  def played?
    !self.answers.empty?
  end
end
