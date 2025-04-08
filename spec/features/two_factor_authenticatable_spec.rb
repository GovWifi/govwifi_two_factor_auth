# frozen_string_literal: true

require "spec_helper"

feature "User of two factor authentication" do
  context "Using an authenticator app" do
    let(:otp_secret_key) { "secret" }
    let(:user) { create(:user, otp_secret_key:) }

    it "does not send an sms" do
      visit new_user_session_path
      complete_sign_in_form_for(user)
      expect(SmsProvider.messages).to be_empty
    end
    it "submits a valid code" do
      visit new_user_session_path
      complete_sign_in_form_for(user)

      fill_in "code", with: ROTP::TOTP.new(otp_secret_key).now
      click_button "Submit"

      within(".flash.notice") do
        expect(page).to have_content("Two factor authentication successful.")
      end

      visit dashboard_path
      expect(page).to have_content("Your Personal Dashboard")
    end
    it "submits an invalid code" do
      visit new_user_session_path
      complete_sign_in_form_for(user)

      fill_in "code", with: "invalid"
      click_button "Submit"

      within(".flash.alert") do
        expect(page).to have_content("Attempt failed.")
      end

      visit dashboard_path
      expect(page).to_not have_content("Your Personal Dashboard")
    end
  end

  context "sending two factor authentication code via SMS" do
    let(:user) { create(:user) }

    it "sends code via SMS after sign in" do
      visit new_user_session_path
      complete_sign_in_form_for(user)

      expect(page).to have_content "Enter the code that was sent to you"

      expect(SmsProvider.messages.size).to eq(1)
      message = SmsProvider.last_message
      expect(message.to).to eq(user.phone_number)
      expect(message.body).to eq(user.reload.direct_otp)
    end

    it "authenticates a valid OTP code" do
      visit new_user_session_path
      complete_sign_in_form_for(user)

      expect(page).to have_content("You are signed in as Marissa")

      fill_in "code", with: SmsProvider.last_message.body
      click_button "Submit"

      within(".flash.notice") do
        expect(page).to have_content("Two factor authentication successful.")
      end

      expect(current_path).to eq root_path

      visit dashboard_path
      expect(page).to have_content("Your Personal Dashboard")
    end
  end

  scenario "must be logged in" do
    visit user_two_factor_authentication_path

    expect(page).to have_content("Welcome Home")
    expect(page).to have_content("You are signed out")
  end

  context "when logged in" do
    let(:user) { create(:user) }

    background do
      login_as user
    end

    scenario "is redirected to TFA when path requires authentication" do
      visit "#{dashboard_path}?A=param%20a&B=param%20b"

      expect(page).to_not have_content("Your Personal Dashboard")

      fill_in "code", with: SmsProvider.last_message.body
      click_button "Submit"

      expect(page).to have_content("Your Personal Dashboard")
      expect(page).to have_content("You are signed in as Marissa")
      expect(page).to have_content("Param A is param a")
      expect(page).to have_content("Param B is param b")
    end

    scenario "is locked out after max failed attempts" do
      visit user_two_factor_authentication_path

      max_attempts = User.max_login_attempts

      max_attempts.times do
        fill_in "code", with: "incorrect#{rand(100)}"
        click_button "Submit"

        within(".flash.alert") do
          expect(page).to have_content("Attempt failed")
        end
      end

      expect(page).to have_content("Access completely denied")
      expect(page).to have_content("You are signed out")
    end

    scenario "cannot retry authentication after max attempts" do
      user.update_attribute(:second_factor_attempts_count, User.max_login_attempts)

      visit user_two_factor_authentication_path

      expect(page).to have_content("Access completely denied")
      expect(page).to have_content("You are signed out")
    end

    describe "rememberable TFA" do
      before do
        @original_remember_otp_session_for_seconds = User.remember_otp_session_for_seconds
        User.remember_otp_session_for_seconds = 30.days
      end

      after do
        User.remember_otp_session_for_seconds = @original_remember_otp_session_for_seconds
      end

      scenario "doesn't require TFA code again within 30 days" do
        sms_sign_in

        logout

        login_as user
        visit dashboard_path
        expect(page).to have_content("Your Personal Dashboard")
        expect(page).to have_content("You are signed in as Marissa")
      end

      scenario "requires TFA code again after 30 days" do
        sms_sign_in

        logout

        Timecop.travel(30.days.from_now)
        login_as user
        visit dashboard_path
        expect(page).to have_content("You are signed in as Marissa")
        expect(page).to have_content("Enter the code that was sent to you")
      end

      scenario "TFA should be different for different users" do
        sms_sign_in

        tfa_cookie1 = get_tfa_cookie

        logout
        reset_session!

        user2 = create(:user)
        login_as(user2)
        sms_sign_in

        tfa_cookie2 = get_tfa_cookie

        expect(tfa_cookie1).not_to eq tfa_cookie2
      end

      def sms_sign_in
        SmsProvider.messages.clear
        visit user_two_factor_authentication_path
        fill_in "code", with: SmsProvider.last_message.body
        click_button "Submit"
      end

      scenario "TFA should be unique for specific user" do
        sms_sign_in

        tfa_cookie1 = get_tfa_cookie

        logout
        reset_session!

        user2 = create(:user)
        set_tfa_cookie(tfa_cookie1)
        login_as(user2)
        visit dashboard_path
        expect(page).to have_content("Enter the code that was sent to you")
      end

      scenario "Delete cookie when user logs out if enabled" do
        user.class.delete_cookie_on_logout = true

        login_as user
        logout

        login_as user

        visit dashboard_path
        expect(page).to have_content("Enter the code that was sent to you")
      end
    end

    it "Redirects to the 2fa page" do
      visit "#{dashboard_path}?A=param%20a&B=param%20b"

      expect(page).to have_content("You are signed in")
      expect(page).to have_content("Enter the code")
    end
  end
end
