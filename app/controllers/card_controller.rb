class CardController < ApplicationController
  before_action :set_card
  
  require "payjp"
  def edit
  end

  def new
    redirect_to action: "show" if card.exists?
  end

  def pay 

    Payjp.api_key = "sk_test_91003e190358af26fd6a2f2c"
    if params['payjp-token'].blank?
      redirect_to action: "new"
    else
      customer = Payjp::Customer.create(
      description: '登録テスト',
      email: current_user.email,
      
      card: params['payjp-token'],
      metadata: {user_id: current_user.id}
      )
      @card = Card.new(user_id: current_user.id, customer_id: customer.id, card_id: customer.default_card)
      if @card.save
        
        redirect_to action: "show"
      else
        
        redirect_to action: "pay"
        
      end
    end
  end

  def delete
    if card.blank?
    end
      redirect_to action: "new"
  end

  def show
    if card.blank?
      redirect_to action: "new" 
    else
      Payjp.api_key = "sk_test_91003e190358af26fd6a2f2c"
      customer = Payjp::Customer.retrieve(card.customer_id)
      @default_card_information = customer.cards.retrieve(card.card_id)
    end
  end

  private

  def set_card
    @card = Card.where(user_id: current_user.id).first
  end

end