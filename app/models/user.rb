class User
  include Mongoid::Document
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  field :first_name
  field :last_name
  references_many :sessions
  
  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name

  # names are capitalized before validation
  before_validation do
    [:first_name, :last_name].each do |symbol|
      self.send(symbol).capitalize! if attribute_present? symbol
    end
  end

  # greeter_name is used to greet user
  def greeter_name
    return email if(first_name.blank? and last_name.blank?)
    "#{first_name} #{last_name}".strip
  end

  # propose a session to a conference
  def propose(session, conference)
    session.tap do |s|
      s.user = self
      s.conference = conference
    end.save!
    self
  end
end
