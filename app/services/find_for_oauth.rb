class FindForOauth

  attr_reader :auth

  def initialize(auth)
    @auth = auth
  end

  def call
    authorization = Authorization.find_by(provider: auth.provider, uid: auth.uid.to_s)
    return authorization.user if authorization

    email = auth.info[:email]
    user = User.find_by(email: email)

    if user
      user.authorizations.create!(provider: auth.provider, uid: auth.uid)
    elsif email
      password = Devise.friendly_token[0, 20]

      User.transaction do
        user = User.create!(email: email,
                            password: password,
                            password_confirmation: password,
                            confirmed_at: Time.zone.now)
        user.authorizations.create!(provider: auth.provider, uid: auth.uid)
      end
    else
      user = User.new
    end

    user
  end
end
