# frozen_string_literal: true

describe "resend_code", type: :request do
  let(:user) { create(:user) }
  before do
    post user_session_path(user: { email: user.email, password: "password" })
  end
  it "resends the code" do
    expect {
      post user_two_factor_authentication_resend_code_path
    }.to change {
      SmsProvider.messages.length
    }.by(1)
    message = SmsProvider.messages.last
    expect(message.to).to eq(user.phone_number)
    expect(message.body).to eq(user.reload.direct_otp)
  end
  it "changes the users' OTP" do
    expect { post user_two_factor_authentication_resend_code_path }.to(change { user.reload.direct_otp })
  end
end
