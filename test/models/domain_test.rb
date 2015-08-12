require 'test_helper'

class DomainTest < ActiveSupport::TestCase
  
  def setup
      @user = User.create(name: "Bob", email: "bobqw@alice.com", password: "password", password_confirmation: "password")
      @domain = Domain.new(name: "crypsis", user_id: @user.id)
  end

  test "domain name should not be empty" do 

      @domain.name = "    "
      assert_not @domain.valid?
  end

  test "domain name have lenght less than 25" do 
      @domain.name = "a"*32
      assert_not @domain.valid?

  end

  test "domain should associated with some user" do 
      #@user.destroy
      @domain.user_id = nil
      assert_not @domain.valid?
  end

end
