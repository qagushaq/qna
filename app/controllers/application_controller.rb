class ApplicationController < ActionController::Base
  before_action :gon_user, unless: :devise_controller?

  private

  def gon_user
    gon.current_user_id = current_user&.id
  end
end
