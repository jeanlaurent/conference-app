require 'spec_helper'

describe Auth::CallbacksController do
  # before(:suite) do
  #   Devise::OmniAuth.test_mode!
  #   Devise::OmniAuth.short_circuit_authorizers!
  # end
  # after(:suite) do
  #   Devise::OmniAuth.unshort_circuit_authorizers!
  # end
  before do
    # see https://github.com/plataformatec/devise/issues/issue/608
    # or http://www.lostincode.net/blog/testing-devise-controllers
    request.env['devise.mapping'] = Devise.mappings[:user]
  end
  
  describe "twitter" do
    before do
      # this is a piece of information sent from twitter
      request.env['omniauth.auth'] = Twitter.data
      assert {Twitter.data['extra'] =~ /CookieOverflow$/}
    end
    context "no user having provider and uid" do
      before do
        get :twitter
      end
      it 'redirects to user sign up page, requiring to fill in email' do
        response.should redirect_to new_user_registration_path
      end
      it 'should have twitter authentication data available in session[:auth]' do
        assert {session[:auth] == Twitter.data.except('credentials', 'extra')}
      end
    end
    context "with a user already authorized" do
      before do
        auth = Fabricate(:authentication, Twitter.data.except('credentials', 'extra', 'user_info'))
        u = Fabricate(:user)
        u.authentications << auth
        assert {u.persisted?}
      end
      it 'should redirect to root_path' do
        get :twitter
        response.should redirect_to root_path
      end
      it 'should sign in user' do
        get :twitter
        assert {controller.current_user}
      end
    end
  end
end