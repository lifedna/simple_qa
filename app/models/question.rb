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
  
  delegate :email, :to => :user, :allow_nil => true, :prefix => true
  
  voteable self, :up => +1, :down => -1
    
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
  
  # Compound index _id and voters.up, _id and voters.down
  # to make up_voted_by, down_voted_by, voted_by scopes and voting faster
  index [['votes.up', 1], ['_id', 1]]
  index [['votes.down', 1], ['_id', 1]]

  # Index counters and point for desc ordering
  index [['votes.count', -1]]
  index [['votes.up_count', -1]]
  index [['votes.down_count', -1]]
  index [['votes.point', -1]]
  index [['answers_count', -1]]

  scoped_order 'votes.count', 'votes.up_count', 'votes.down_count', 'votes.point', 'answers_count'
end
