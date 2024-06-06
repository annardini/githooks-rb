# frozen_string_literal: true

require "test_helper"

class HookgitTest < Test::Unit::TestCase
  test "VERSION" do
    assert do
      ::Hookgit.const_defined?(:VERSION)
    end
  end

  test "something useful" do
    assert_equal("expected", "actual")
  end
end
