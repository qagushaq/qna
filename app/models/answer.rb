class Answer < ApplicationRecord

  include Votable
  include Commentable

  belongs_to :question
  belongs_to :user

  has_many :links, dependent: :destroy, as: :linkable

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  has_many_attached :files

  validates :body, presence: true
  validates :best, uniqueness: { scope: :question_id, best: true }, if: :best?

  default_scope { order('best DESC, created_at') }

  def make_best!
    transaction do
      question.answers.update_all(best: false)
      update!(best: true)
      question.award&.update!(user: user)
    end
  end
end
