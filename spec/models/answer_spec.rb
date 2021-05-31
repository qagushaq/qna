require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should belong_to :user }

  it { should have_db_index :question_id }
  it { should validate_presence_of :body }

  let(:question) { create(:question) }
  let!(:best_answer) { create(:answer, question: question, best: true) }
  let(:best_answer2) { create(:answer, question: question, best: true) }
  let!(:answer) { create(:answer, question: question) }

  context 'validation of uniqueness of the best answer' do
    it 'should raise error for second best answer'  do
      expect { best_answer2 }.to raise_error
    end

    it 'not should raise error for not the best answer' do
      expect { answer }.not_to raise_error
    end
  end

  context '#make_best' do
    before { answer.make_best! }

    it 'makes answer the best' do
      expect(answer).to be_best
    end

    it 'makes best_answer not the best' do
      best_answer.reload
      expect(best_answer).to_not be_best
    end
  end

  context '.default_scope' do
    let!(:new_best_answer) { create(:answer, question: question) }
    before { new_best_answer.make_best! }

    it 'should sort array by best and created_at' do
      expect(question.answers.to_a).to be_eql [new_best_answer, best_answer, answer]
    end
  end
end
