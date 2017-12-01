class Quiz < ApplicationRecord
  has_many :questions
  has_many :answers, through: :questions
  has_many :options, through: :questions

  def played?
    !self.answers.empty?
  end
end
