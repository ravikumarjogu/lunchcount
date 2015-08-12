require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

    def setup
        @user =users(:bob)
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

       #assert_template root_url
    end

end
