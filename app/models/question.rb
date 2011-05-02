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
  
  validates :title, :presence => true, :length => { :minimum => 5 }
  validates :body, :presence => true 
  
  has_many :answers
  belongs_to :user
  
  delegate :email, :to => :user, :allow_nil => true, :prefix => true
  
  voteable self, :up => +1, :down => -1, :index => true
  
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
  
  # Index counter desc ordering
  index [['answers_count', -1]]

  scoped_order 'votes.count', 'votes.up_count', 'votes.down_count', 'votes.point', 'answers_count'
end
