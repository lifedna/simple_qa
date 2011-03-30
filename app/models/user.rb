class User
  include Mongoid::Document
  include Mongoid::Voter
  devise :database_authenticatable, :registerable, :rememberable
         
  has_many :questions
  has_many :answers  
end
