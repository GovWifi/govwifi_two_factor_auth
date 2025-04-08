# frozen_string_literal: true

describe "show", type: :request do
  it "requires authentication" do
    get user_two_factor_authentication_path
    expect(response).to redirect_to "/"
  end
  it "renders the show page when authenticated" do
    user = create(:user)
    post user_session_path(user: { email: user.email, password: "password" })

    get user_two_factor_authentication_path
    expect(response).to have_http_status(:success)
  end
end
