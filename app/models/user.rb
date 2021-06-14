class User < ApplicationRecord
  has_many :questions
  has_many :answers
  has_many :awards

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def is_author?(resource)
    self.id == resource.user_id
  end
end
