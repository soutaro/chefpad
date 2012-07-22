class Recipe < ActiveRecord::Base
  attr_accessible :title, :body

  validates_presence_of :title, :body
  validates_presence_of :account
  validates_associated :account
  
  belongs_to :account
  
  def as_json(*args)
    {
      :id => self.id,
      :created_at => self.created_at,
      :updated_at => self.updated_at,
      :title => self.title,
      :body => self.body,
      :account => self.account.as_json(*args),
    }
  end
end
