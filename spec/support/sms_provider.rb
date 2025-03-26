# frozen_string_literal: true

require_relative "../lib/sms_provider"
RSpec.configure do |c|
  c.before(:each) do
    SmsProvider.messages.clear
  end
end
