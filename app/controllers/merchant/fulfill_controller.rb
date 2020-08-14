class Merchant::FulfillController < Merchant::BaseController
  def update
    item_order = ItemOrder.find(params[:item_order_id])
    item_order.fulfill
    # item_order.update(status: "fulfilled")
    # item_order.item.update_inventory(item_order.quantity)
    flash[:success] = "Item has been successfully fulfilled"
    redirect_to "/merchant/orders/#{item_order.order.id}"
  end
end
