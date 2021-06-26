class OauthCallbacksController < Devise::OmniauthCallbacksController
before_action :sign_in_with_provider, only: %i(github vkontakte)

  def github
  end

  def vkontakte
  end

  private

  def sign_in_with_provider
    auth = request.env['omniauth.auth']
    @user = User.find_for_oauth(auth)

    if @user&.persisted?
      sign_in_and_redirect(@user, event: :authentication)
      set_flash_message(:notice, :success, kind: auth.provider.capitalize) if is_navigational_format?
    elsif @user
      session[:provider] = auth.provider
      session[:uid] = auth.uid
      redirect_to new_user_confirmation_path, notice: 'Please provide your email'
    else
      redirect_to root_path, alert: 'Something wrong'
    end
  end
end
