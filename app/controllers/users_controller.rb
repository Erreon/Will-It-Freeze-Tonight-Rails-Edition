class UsersController < ApplicationController
  before_filter :require_login, :except => [:new, :create]
  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to root_url, :notice => "Signed up!"
    else
      render :new
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if params[:phone_number]
      @user.phone_number = params[:phone_number].gsub(/\D/, "")
    end
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { render action: "edit", notice: 'User account was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def new_subscription
    @user = current_user
    render :new_subscription
  end
  
  def subscribe
    @user = current_user
    
    respond_to do |format|
      if @user.save_with_payment(params[:user])
        format.html { redirect_back_or_to root_url, notice: 'Thank you for subscribing!' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def resubscribe
    @user = current_user
    customer = Stripe::Customer.retrieve(@user.stripe_customer_token)
    customer.update_subscription(:plan => 1)
    @user.subscription = 1

    if @user.save
      redirect_to root_url, notice: "Thank you for resubscribing!"
    end
  end
  
  def unsubscribe
    @user = current_user
    @user.subscription = 0
    customer = Stripe::Customer.retrieve(@user.stripe_customer_token)
    customer.cancel_subscription
    
    if @user.save
      redirect_to root_url, notice: 'Unsubscribed.  I hope you come back again.'
    end
  end

end
