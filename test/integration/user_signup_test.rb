require 'test_helper'

class UserSignupTest < ActionDispatch::IntegrationTest
  def setup
      @user = users(:bob)
  end

    test "invalid signup" do 
        get new_user_registration_path
        assert_template 'devise/registrations/new'
        assert_no_difference 'User.count' do 

          post user_registration_path, { name:  "",
                               email: "user@invalid",
                               password:              "foo",
                               password_confirmation: "bar" }
       end
        
       assert_template 'devise/registrations/new'

    end

    test "valid sign up" do 
        get new_user_registration_path
        assert_template 'devise/registrations/new'
        assert_no_difference 'User.count' do 

          post user_registration_path, { name:  "bob",
                               email: "user@valid.com",
                               password:              "foobar12",
                               password_confirmation: "foobar12" }
       end
      
      #assert_match 'User.count', "1"
      #assert user_signed_in?


    end

    test "invalid sign in" do 
        get new_user_session_path
        assert_template 'devise/sessions/new'
        post user_session_path, user: { email: "",
                                           password: ""}
        assert_template 'devise/sessions/new'


    end

    test "valid sign in" do 

        post user_session_path, user: { email: @user.email,
                                           password: 'password'}

       # assert_template 'static_pages/index'
       #assert_not current_user.nil?
    end
end
