class Answer
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Voteable
  
  field :content, :type => String
  
  belongs_to :question
  belongs_to :user
  
  voteable self, :up => +1, :down => -2
  voteable Question, :up => +2, :down => -1#, :update_counters => false # to skip up_votes_count, down_votes_count & votes_count update on Question
end
