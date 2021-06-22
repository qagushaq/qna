class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_commented, only: %i[create]

  after_action :publish_comment, only: %i[create]

  def create
    @comment = @commented.comments.create(comment_params.merge(user: current_user))
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def find_commented
    klass = [Question, Answer].find{|c| params["#{c.name.underscore}_id"]}
    @commented = klass.find(params["#{klass.name.underscore}_id"])
  end

  def publish_comment
    return if @comment.errors.any?

    id = @commented.is_a?(Question) ? @commented.id : @commented.question.id

    data = {
      comment: @comment,
      commented_id: "#{@commented.class.to_s.downcase}-#{@commented.id}",
      user: @comment.user
    }

    ActionCable.server.broadcast("comment_question_#{id}", data)
  end
end
