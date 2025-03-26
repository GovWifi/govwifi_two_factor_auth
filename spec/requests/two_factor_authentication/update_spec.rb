# frozen_string_literal: true

describe "update", type: :request do
  let(:second_factor_attempts_count) { 1 }
  let(:user) { create(:user) }
  it "requires authentication" do
    put user_two_factor_authentication_path, params: { code: user.reload.direct_otp }
    expect(response).to redirect_to "/"
  end
  describe "the user has authenticated" do
    before do
      post user_session_path(user: { email: user.email, password: "password" })
    end
    it "requires a code parameter" do
      put user_two_factor_authentication_path
      expect(response).to have_http_status(:success)
    end
    it "redirects if 2fa is correct" do
      put user_two_factor_authentication_path, params: { code: user.reload.direct_otp }
      expect(response).to redirect_to root_path
    end
    it "resets the second_factor_attempts_count" do
      put user_two_factor_authentication_path, params: { code: user.reload.direct_otp }
      expect(user.reload.second_factor_attempts_count).to eq 0
    end
    it "shows 2fa page if 2fa is incorrect" do
      put user_two_factor_authentication_path, params: { code: "invalid" }
      expect(response).to have_http_status(:success)
    end
    it "increases the second_factor_attempts_count if 2fa is incorrect" do
      expect {
        put user_two_factor_authentication_path, params: { code: "invalid" }
      }.to change { user.reload.second_factor_attempts_count }.by(1)
    end
    it "rejects and signs out when there are too many failures" do
      user.update!(second_factor_attempts_count: 10)
      put user_two_factor_authentication_path, params: { code: "invalid" }
      expect(response.body).to include("Access completely denied as you have reached your attempts limit")
      expect(response.body).to include("You are signed out")
    end
  end
end
