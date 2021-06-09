class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  has_many :links, dependent: :destroy, as: :linkable

  accepts_nested_attributes_for :links, reject_if: :all_blank

  has_many_attached :files

  validates :body, presence: true
  validates :best, uniqueness: { scope: :question_id, best: true }, if: :best?

  default_scope { order('best DESC, created_at') }

  def make_best!
    transaction do
      question.answers.update_all(best: false)
      update!(best: true)
    end
  end
end
