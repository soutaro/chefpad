class ApiController < ApplicationController
  before_filter :load_account_from_session, :except => :create_session
  
  def create_session
    account = Account.authenticate(params[:email], params[:password])
    
    unless account
      return render(:status => :forbidden, :nothing => true)
    end
    
    session = ApiSession.generate(account)
    session.save!
    
    render :status => :created, :json => session 
  end
  
  def account
    render :json => { "account" => current_account }
  end
  
  def create_recipe
    recipe = current_account.recipes.new(params[:recipe])
    if recipe.save
      render :status => :created, :json => { :recipe => recipe }
    else
      render :status => :forbidden, :nothing => true
    end
  end
  
  def index_recipes
    recipes = Recipe.limit(100).order("created_at DESC")
    
    render :status => :ok, :json => { :recipes => recipes }
  end
  
  private
  
  def load_account_from_session
    session = ApiSession.load(params[:token])
    unless session
      return render :status => :forbidden, :nothing => true
    end
    
    @account_ = session.account
  end
  
  def current_account
    @account_
  end
end
