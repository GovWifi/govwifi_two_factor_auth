# frozen_string_literal: true

require "govwifi_two_factor_auth/version"
require "devise"
require "active_support/concern"
require "active_model"
require "active_support/core_ext/class/attribute_accessors"
require "cgi"
require "govwifi_two_factor_auth/railtie"

module Devise
  @max_login_attempts = 3
  @allowed_otp_drift_seconds = 30
  @otp_length = 6
  @direct_otp_length = 6
  @direct_otp_valid_for = 5.minutes
  @remember_otp_session_for_seconds = 0
  @otp_secret_encryption_key = ""
  @second_factor_resource_id = "id"
  @delete_cookie_on_logout = false
  class << self
    attr_accessor :max_login_attempts, :allowed_otp_drift_seconds, :otp_length, :direct_otp_length, :direct_otp_valid_for, :remember_otp_session_for_seconds, :otp_secret_encryption_key, :second_factor_resource_id, :delete_cookie_on_logout
  end
end

module GovwifiTwoFactorAuth
  NEED_AUTHENTICATION = "need_two_factor_authentication"
  REMEMBER_TFA_COOKIE_NAME = "remember_tfa"

  autoload :Schema, "govwifi_two_factor_auth/schema"
  module Controllers
    autoload :Helpers, "govwifi_two_factor_auth/controllers/helpers"
  end
end

Devise.add_module :two_factor_authenticatable, model: "govwifi_two_factor_auth/models/two_factor_authenticatable",
                                               controller: :two_factor_authentication, route: :two_factor_authentication

require "govwifi_two_factor_auth/orm/active_record" if defined?(ActiveRecord::Base)
require "govwifi_two_factor_auth/routes"
require "govwifi_two_factor_auth/models/two_factor_authenticatable"
require "govwifi_two_factor_auth/rails"
