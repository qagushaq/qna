require 'rails_helper'

shared_examples_for 'voted' do
  let!(:author) { create(:user) }
  let!(:user) { create(:user) }
  let!(:vote) { create(:vote, votable: voted) }

  describe 'POST #vote' do
    context 'for not votable author' do
      before { login(user) }

      it 'saves a new vote in db' do
        expect { post :vote, params: { id: voted,
                                       voted: { value: 1 },
                                       format: :json } }.to change(Vote, :count).by(1)
      end

      it 'render valid json' do
        post :vote, params: { id: voted, voted: { value: 1 }, format: :json }

        expected = { votable_type: voted.class.to_s.downcase,
                     votable_id: voted.id,
                     rating: voted.rating
        }.to_json

        expect(response) == expected
      end
    end

    context 'for votable author' do
      before { login(author) }

      it 'does not create new vote' do
        expect { post :vote, params: { id: voted,
                                       voted: { value: 1 },
                                       format: :json } }.to_not change(Vote, :count)
      end

      it 'returns 204: No Content' do
        post :vote, params: { id: voted, voted: { value: 1 }, format: :json }

        expect(response.status).to eq 204
      end
    end

    context 'for unauthorized user' do
      it 'does not create new vote' do
        expect { post :vote, params: { id: voted,
                                       voted: { value: 1 },
                                       format: :json } }.to_not change(Vote, :count)
      end

      it 'returns 401: Unauthorized' do
        post :vote, params: { id: voted, voted: { value: 1 }, format: :json }

        expect(response.status).to eq 401
      end
    end
  end

  describe 'POST #revote' do
    context 'for vote author' do
      before { login(vote.user) }

      it 'deletes a vote from db' do
        expect { post :revote, params: { id: voted, format: :json } }.to change(Vote, :count).by(-1)
      end

      it 'render valid json' do
        post :revote, params: { id: voted, format: :json }

        expected = { votable_type: voted.class.to_s.downcase,
                     votable_id: voted.id,
                     rating: voted.rating
                   }.to_json

        expect(response) == expected
      end
    end

    context 'for not vote author' do
      before { login(user) }

      it 'does not delete a vote from db' do
        expect { post :revote, params: { id: voted, format: :json } }.to_not change(Vote, :count)
      end

      it 'returns 200: OK' do
        post :revote, params: { id: voted, format: :json }

        expect(response.status).to eq 200
      end
    end

    context 'for unauthorized user' do
      it 'does not create new vote' do
        expect { post :revote, params: { id: voted, format: :json } }.to_not change(Vote, :count)
      end

      it 'returns 401: Unauthorized' do
        post :revote, params: { id: voted, format: :json }

        expect(response.status).to eq 401
      end
    end
  end
end
