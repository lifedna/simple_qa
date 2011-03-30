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

  LIST_METHODS = %w[most_up_voted most_down_voted most_voted best_voted]
  LIST_METHOD_OPTIONS = LIST_METHODS.map{ |s| [s.humanize, s] }

  scope :list_by, lambda { |method|
    method = method.to_s
    LIST_METHODS.include?(method) ? try(method) : self
  }
end
