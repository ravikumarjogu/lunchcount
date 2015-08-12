require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
      @user=User.new(name: "Example User", email: "user@example.com",password: "foobar90", password_confirmation: "foobar90")
  end

  test "should be valid" do 
      assert @user.valid?
  end
  test "name should not null" do 
      @user.name = "       "
      assert_not @user.valid?
  end
  test "email should not null" do 
      @user.email = "  "
      assert_not @user.valid?
  end

  test "name length" do
      @user.name = "a"*32
      assert_not @user.valid?
  end

  test "email length" do 
      @user.email = "a"*250 +"@example.com"
      assert_not @user.valid?
  end
  test "email validation should accept valid addresses" do 
      valid_addresses= %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]

      valid_addresses.each do |valid_address|
        @user.email=valid_address
        assert @user.valid?, "#{valid_address.inspect} should be valid"

      end
  end

  test "unique email allowed" do 
      dup_user=@user.dup
      dup_user.email = @user.email.downcase
      @user.save
      assert_not dup_user.valid?

  end


end
