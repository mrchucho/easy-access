$:.unshift(File.dirname(__FILE__) + '/../test/lib')
require 'test/unit'
# Example Module and Models
require 'access_system'
require 'read_only_model'
require 'restricted_model'

class Role
  attr_accessor :name
end

class User
  include AccessSystem
end

class EasyAccessTest < Test::Unit::TestCase

  def test_including_access_system
    user = User.new
    [:can_view?, :can_destroy?, :can_create?, :can_update?].each do |access_method|
      assert user.respond_to?(access_method)
    end
  end

  def test_read_only_model
    ro = ReadOnlyModel.new
    user = User.new

    assert user.can_view?(ro)
    assert_equal false, user.can_destroy?(ro)
    assert_equal false, user.can_create?(ro)
    assert_equal false, user.can_update?(ro)
  end

  def test_restricted_model_for_owner
    user = User.new
    class << user
      def roles
        r = Role.new
        r.name = "Destroyer"
        [r]
      end
    end
    model = RestrictedModel.new(user)

    assert user.can_view?(model)
    assert user.can_destroy?(model)
    assert_equal false, user.can_create?(model) # by default
    assert user.can_update?(model)
  end

  def test_restricted_model_for_non_owner
    owner = User.new
    model = RestrictedModel.new(owner)
    user = User.new
    class << user 
      def roles
        []
      end
    end

    assert_equal false, user.can_view?(model)
    assert_equal false, user.can_destroy?(model)
    assert_equal false, user.can_create?(model)
    assert_equal false, user.can_update?(model)
  end
end
