class Question < ApplicationRecord
  belongs_to :quiz
  has_many :options, dependent: :destroy
  has_many :answers, dependent: :destroy

  ## RENDER FOLLOWING QUESTION ID OR NIL IF LAST
  def next_id
    self.class.where("id > ? and quiz_id = ?", self.id, self.quiz_id).pluck(:id).first
  end

  ## RENDER PREVIOUS QUESTION ID OR NIL IF FIRST
  def previous_id
    self.class.where("id < ? and quiz_id = ?", self.id, self.quiz_id).pluck(:id).last
  end

  ## CHECK IF ID IS FIRST
  def first?
    self.previous_id.nil?
  end

  ## CHECK IF ID IS LAST
  def last?
    self.next_id.nil?
  end

  def correct_answer
    Option.where("question_id = ? and correct", self.id).first
  end
end
