require 'test_helper'

class ApiSessionTest < ActiveSupport::TestCase
  test "generate and load session" do
    session = ApiSession.generate(accounts(:one))
    assert_not_nil session
    assert session.save
    
    token = session.token
    
    assert_not_nil ApiSession.load(token)
    assert_equal accounts(:one), ApiSession.load(token).account
    
    assert_nil ApiSession.load("no such token")
  end
end
