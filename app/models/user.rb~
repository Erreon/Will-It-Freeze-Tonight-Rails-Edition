class User < ActiveRecord::Base
  authenticates_with_sorcery!
  
  attr_accessible :username, :email, :password, :password_confirmation, :subscription
  
  attr_accessor :stripe_card_token 
  
  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :username
  validates_uniqueness_of :username
  validates_presence_of :email
  validates_uniqueness_of :email
  
  def save_with_payment(params)
    print params 
    if valid?
      customer = Stripe::Customer.create(description: params['username'], plan: params['subscription'], card: params['stripe_card_token'])
      self.stripe_customer_token = customer.id
      self.subscription = params['subscription']
      save!
    end
  end
end

