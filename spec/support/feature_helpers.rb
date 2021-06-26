module FeatureHelpers
  def sign_in(user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
  end

  def auth_with(provider, email = nil)
    hash = OmniAuth::AuthHash.new({ provider: provider.to_s, uid: '123',
                                    info: { name: 'test test' }
    })
    hash.info.merge!(email: email) if email
    OmniAuth.config.mock_auth[provider] = hash
  end
end
