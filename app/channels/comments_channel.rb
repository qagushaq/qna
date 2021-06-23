class CommentsChannel < ApplicationCable::Channel
  def follow(data)
    stream_from "comment_question_#{data['id']}"
  end
end
