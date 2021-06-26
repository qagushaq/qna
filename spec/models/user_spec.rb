require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many :questions }
  it { should have_many :answers }
  it { should have_many :awards }
  it { should have_many :votes }
  it { should have_many :comments }
  it { should have_many(:authorizations).dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe 'voted' do
    let!(:questions) { create_list(:question, 2)}
    let!(:user) { create(:user) }
    let!(:vote) { create(:vote, user: user, votable: questions[0])}

    it 'shows whether the user voted' do
      expect(user.voted?(questions[0])).to be_truthy
      expect(user.voted?(questions[1])).to be_falsey
    end
  end

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }
    let(:service) { double('FindForOauth') }

    it 'calls FindForOauth' do
      expect(FindForOauth).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)
      User.find_for_oauth(auth)
    end
  end

end

describe 'instance methods is_author?' do

  describe '#is_author? will return the true ' do

    context 'user is author' do
      let(:user){ create(:user) }
      let(:question){ create(:question, user_id: user.id) }
      let(:answer){ create(:answer, user_id: user.id) }

      it 'returns true for answer' do
        expect(user.is_author?(answer)).to be true
      end

      it 'returns true for question' do
        expect(user.is_author?(question)).to be true
      end
    end

    context 'user is not author' do
      let(:user){ create(:user) }
      let(:question){ create(:question) }
      let(:answer){ create(:answer) }

      it 'returns false for answer' do
        expect(user.is_author?(answer)).to be false
      end

      it 'returns false for question' do
        expect(user.is_author?(question)).to be false
      end
    end
  end
end
