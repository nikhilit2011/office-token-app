class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: {
    admin: "admin",
    token_operator: "token_operator",
    counter_incharge: "counter_incharge"
  }

  has_many :tokens
  
  validates :role, presence: true
end
