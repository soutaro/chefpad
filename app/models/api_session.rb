class ApiSession < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :account

  validates_uniqueness_of :token
  validates_presence_of :account
  validates_associated :account

  def self.generate(account)
    if account.api_sessions.exists?
      return account.api_sessions.first
    end
    
    session = ApiSession.new
    session.account = account
    session.token = SecureRandom.hex(40)
    session
  end
  
  def self.load(token)
    ApiSession.where(token: token).first
  end
  
  def as_json(*args)
    {
      :token => self.token,
      :created_at => self.created_at,
    }
  end
end
