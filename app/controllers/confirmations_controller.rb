class ConfirmationsController < Devise::ConfirmationsController
  def create
    email = user_params[:email]
    password = Devise.friendly_token[0, 20]

    @user = User.new(email: email,
                     password: password,
                     password_confirmation: password)

    if @user.save
      @user.send_confirmation_instructions
      redirect_to root_path, notice: 'Confirm your email'
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:email)
  end

  def after_confirmation_path_for(resource_name, user)
    provider_data = { provider: session[:provider], uid: session[:uid] }
    user.authorizations.create!(provider_data) if provider_data.values.all?
    session[:provider] = nil
    session[:uid] = nil

    sign_in(user, event: :authentication)
    signed_in_root_path(user)
  end
end
