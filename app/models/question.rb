class Question
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Voteable
  include Mongoid::Slug
  include ScopedSearch::Model
  
  field :title, :type => String
  field :body, :type => String

  slug :title, 
    :permanent => true, # Don't change slug in the future
    :index => true
  
  validates :title, :presence => true, :length => { :minimum => 10 }
  validates :body, :presence => true 
  
  has_many :answers
  belongs_to :user
  
  voteable self, :up => +1, :down => -1
    
  field :answers_count, :type => Integer, :default => 0

  def self.inc_counter(id, field, value)
    collection.update({ '_id' => id }, {
      '$inc' => { field => value }
    })
  end
    
  def answers_count
    unless count = read_attribute('answers_count')
      count = answers.count
      write_attribute('answers_count', count)
      Question.inc_counter(id, 'answers_count', count)
    end
    count
  end

  index VOTES_COUNT
  index VOTES_POINT
  index [[:answers_count, -1]]

  scoped_order VOTES_POINT, VOTES_COUNT, :answers_count
end
