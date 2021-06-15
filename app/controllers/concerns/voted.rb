module Voted
  extend ActiveSupport::Concern

  included do
    before_action :find_voted, only: %i[vote revote]
  end

  def vote
    unless current_user.is_author?(@voted)
      @voted.votes.create!(votes_params.merge(user: current_user))

      render json: json_data
    end
  end

  def revote
    unless current_user.is_author?(@voted)
      vote = @voted.votes.where(user: current_user)
      vote.destroy_all

      render json: json_data
    end
  end

  private

  def votes_params
    params.require(:voted).permit(:value)
  end

  def model_class
    controller_name.classify.constantize
  end

  def find_voted
    @voted = model_class.find(params[:id])
  end

  def json_data
    {
      votable_type: @voted.class.to_s.downcase,
      votable_id: @voted.id,
      rating: @voted.rating
    }
  end
end
