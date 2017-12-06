class PlayedCard < ApplicationRecord

  def played?
    !self.choice.nil?
  end

end
