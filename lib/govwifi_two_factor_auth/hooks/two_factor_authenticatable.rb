Warden::Manager.after_authentication do |user, auth, options|
  if auth.env["action_dispatch.cookies"]
    expected_cookie_value = "#{user.class}-#{user.public_send(Devise.second_factor_resource_id)}"
    actual_cookie_value = auth.env["action_dispatch.cookies"].signed[GovwifiTwoFactorAuth::REMEMBER_TFA_COOKIE_NAME]
    bypass_by_cookie = actual_cookie_value == expected_cookie_value
  end

  if user.respond_to?(:need_two_factor_authentication?) && !bypass_by_cookie && (auth.session(options[:scope])[GovwifiTwoFactorAuth::NEED_AUTHENTICATION] =
                                                                                   user.need_two_factor_authentication?(auth.request)) && user.send_new_otp_after_login?
    user.send_new_otp
  end
end

Warden::Manager.before_logout do |_user, auth, _options|
  auth.cookies.delete GovwifiTwoFactorAuth::REMEMBER_TFA_COOKIE_NAME if Devise.delete_cookie_on_logout
end
