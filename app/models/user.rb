class User
  include Mongoid::Document
  include Mongoid::Voter
  devise :database_authenticatable, :registerable, :rememberable, :validatable
  
  has_many :questions
  has_many :answers  
end
