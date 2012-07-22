require 'test_helper'

class ApiControllerTest < ActionController::TestCase
  include UnificationAssertion
  
  def json_response
    JSON.parse(response.body)
  end
  
  test "login success" do
    post(:create_session, :email => "test@example.com", :password => "test123")
    
    assert_response :created
    
    result = json_response
    assert_equal accounts(:one), ApiSession.load(result["token"]).account
  end
  
  test "login failure" do
    post(:create_session, :email => "test@example.com", :password => "invalid password")
    assert_response :forbidden
    
    post(:create_session, :email => "no@such_email.com", :password => "hoge")
    assert_response :forbidden
  end
  
  def signin(email = "test@example.com", password = "test123")
    post(:create_session, :email => email, :password => password)
    
    assert_response :created
    
    result = json_response
    @token = result["token"]
  end
  
  test "account" do
    signin
    
    get(:account, :token => @token)
    assert_response :ok
    
    assert_unifiable({
      "account" => {
        "id" => :_,
        "created_at" => :_,
        "updated_at" => :_,
        "email" => "test@example.com",
      }
    }, json_response)
  end
  
  test "post recipe" do
    signin
    
    post(:create_recipe, :token => @token, :recipe => { :title => "My first recipe", :body => "Do something" })
    
    assert_equal 1, accounts(:one).recipes.count
    assert_unifiable({
      "recipe" => {
        "id" => :_,
        "created_at" => :_,
        "updated_at" => :_,
        "title" => "My first recipe",
        "body" => "Do something",
        "account" => :_,
      }
    }, json_response)
  end
  
  test "index recipe" do
    signin
    
    get(:index_recipes, :token => @token)
    assert_equal({ "recipes" => [] }, json_response)

    post(:create_recipe, :token => @token, :recipe => { :title => "My first recipe", :body => "Do something" })
    assert_response :created
    
    get(:index_recipes, :token => @token)
    assert_unifiable({
      "recipes" => [
        {
          "id" => :_,
          "created_at" => :_,
          "updated_at" => :_,
          "title" => "My first recipe",
          "body" => "Do something",
          "account" => :_,
        }
      ]
    }, json_response)
  end
end
