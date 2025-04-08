# frozen_string_literal: true

module GovwifiTwoFactorAuth
  class Engine < ::Rails::Engine
    ActiveSupport.on_load(:action_controller) do
      include GovwifiTwoFactorAuth::Controllers::Helpers
    end
  end
end
