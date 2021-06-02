class FilesController < ApplicationController
  def destroy
    @file = ActiveStorage::Attachment.find(params[:id])
    @file.purge if current_user&.is_author?(@file.record)
  end
end
