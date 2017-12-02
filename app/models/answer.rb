class Answer < ApplicationRecord
  belongs_to :question

  def is_incorrect?
    self.score == 0
  end
end
