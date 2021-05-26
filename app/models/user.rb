class User < ApplicationRecord
  has_many :questions
  has_many :answers

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
