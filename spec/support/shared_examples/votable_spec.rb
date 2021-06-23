require 'rails_helper'

shared_examples_for 'votable' do
  it { should have_many(:votes).dependent(:destroy) }
  
  let(:user) { create(:user) }
  let(:model) { described_class }
  let(:object) { create(model.to_s.underscore.to_sym)}

  describe '#rating' do
    it 'shows rating equals 0' do
      object.votes.create(user: user)

      expect(object.rating).to eq 0
    end
  end
end
