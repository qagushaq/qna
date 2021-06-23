require 'rails_helper'

RSpec.describe Comment, type: :model do
  it { should belong_to :commentable }
  it { should belong_to :user }

  it { should validate_presence_of :body }

  context '.default_scope' do
    let!(:question) { create(:question) }
    let!(:comments) { create_list(:comment, 2, commentable: question, user: question.user) }

    it 'should sort array by best and created_at' do
      expect(question.comments.to_a).to be_eql [comments[0], comments[1]]
    end
  end
end
