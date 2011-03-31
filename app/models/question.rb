class Question
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Voteable
  include Mongoid::Slug
  include ScopedSearch::Model
  
  field :title, :type => String
  field :body, :type => String

  slug :title
  
  validates :title, :presence => true, :length => { :minimum => 10 }
  validates :body, :presence => true 
  
  has_many :answers
  belongs_to :user
  
  voteable self, :up => +1, :down => -1

  index UP_VOTES_COUNT
  index DOWN_VOTES_COUNT
  index VOTES_COUNT
  index VOTES_POINT
  
  %w[up_votes_count down_votes_count votes_count votes_point].each do |name|
    field = "Mongoid::Voteable::#{name.upcase}".constantize
    scope "ascend_by_#{name}", order_by([ field, :asc ])
    scope "descend_by_#{name}", order_by([ field, :desc ])    
  end
end
