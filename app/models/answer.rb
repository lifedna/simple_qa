class Answer
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Voteable
  
  field :content, :type => String
  
  belongs_to :question
  belongs_to :user
  
  vote_point self, :up => +1, :down => -2
  vote_point Question, :up => +2, :down => -1
end
