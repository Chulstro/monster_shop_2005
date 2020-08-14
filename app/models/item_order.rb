class ItemOrder <ApplicationRecord
  after_initialize :default_status, :set_merchant
  validates_presence_of :item_id, :order_id, :price, :quantity
  belongs_to :item
  belongs_to :order

  enum status: %w(pending packaged unfulfilled fulfilled shipped cancelled)

  def subtotal
    price * quantity
  end

  def fulfill
    update(status: "fulfilled")
    item.update_inventory(quantity)
  end

  private

  def default_status
    self.status = 0 if status.nil?
  end

  def set_merchant
    if !item.nil?
      item = Item.find(self.item_id)
      self.item_merchant_id = item.merchant_id
    end
  end
end
