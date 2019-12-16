class ItemsController < ApplicationController

  def new
  end
  
  def index
    @items = Item.all.order(created_at:"desc").limit(10)
    @images = Image.all
  end

  def buy
    @buyer = Buyer.new
    @seller = Seller.new
    @items = Item.all
    @item = Item.find(params[:id])
    @images = Image.all
  end

  def buy_create
    @item = Item.find(params[:id])
    # @image = Image.find(params[:id])
    @buyer = Buyer.new(buyer_params)
    @buyer.save!
    @seller = Seller.new(seller_params)
    @seller.save!
    if @buyer.save && @seller.save

      @card = Card.where(user_id: current_user.id).first
      Payjp.api_key = 'sk_test_6c130d285ae2b7dd291fc04f'
      Payjp::Charge.create(
      amount: @item.price, #支払金額を入力（itemテーブル等に紐づけても良い）
      customer: @card.customer_id, #顧客ID
      currency: 'jpy' #日本円
    )
    redirect_to root_path 
    else
      render :buy
    end

  end

  def show
    @items = Item.all.order(created_at:"desc").limit(6)
    # @images = Image.all.order(created_at:"desc").limit(6)
    @item = Item.find(params[:id])
    @sold = Buyer.find_by(item_id: @item.id)

  end

  def sell
    @item = Item.new
    @item.images.build
  end

  def create
    @item  = Item.new(item_params)
    if @item.save
      params[:images][:image].each do |image|
        @item.images.create!(image: image, item_id: @item.id)
      end
      redirect_to root_path
    else
      redirect_to sell_items_path
    end
  end


  # source ~/.zshrc
  def item_params
    params.require(:item).permit(:name, :description, :category, :status, :price, :burden, :area, :days)
  end
  private

    def buyer_params
      params.require(:buyer).permit(:user_id, :item_id)
    end

    def seller_params
      params.require(:seller).permit(:user_id, :item_id)
    end
end
