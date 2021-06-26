class User < ApplicationRecord
  has_many :questions
  has_many :answers
  has_many :awards
  has_many :votes
  has_many :comments
  has_many :authorizations, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:github]

  def create_authorization(auth)
    self.authorizations.create(provider: auth.provider, uid: auth.uid)
  end

  def is_author?(resource)
    self.id == resource.user_id
  end

  def voted?(resource)
    votes.where(votable: resource).present?
  end

  def self.find_for_oauth(auth)
    FindForOauth.new(auth).call
  end
end
