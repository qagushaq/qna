class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

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
