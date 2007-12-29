class Faq < ActiveRecord::Base
  belongs_to :user
  
  QUESTIONS = %w(bio skillz schools companies music movies
                  television books magazines)
  # A constant for everything except the bio
  FAVORITES = QUESTIONS - %w(bio)
  TEXT_ROWS = 10
  TEXT_COLS = 40
  
  validates_length_of QUESTIONS, :maximum => DB_TEXT_MAX_LENGTH
  
  def initialize
    super
    QUESTIONS.each do |question|
      self[question] = ""
    end
  end
end
