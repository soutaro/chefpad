class Account < ActiveRecord::Base
  has_many :recipes
  has_many :api_sessions

  has_secure_password

  validates_uniqueness_of :email
  validates_presence_of :password_digest, :on => :create
  
  def self.authenticate(email, password)
    account = Account.where(:email => email).first
    account.try do |a|
      a.authenticate(password)
    end
  end
  
  def as_json(*args)
    {
      :id => self.id,
      :email => self.email,
      :created_at => self.created_at,
      :updated_at => self.updated_at,
    }
  end
end
