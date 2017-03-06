class AddCouponsToRegistrations < ActiveRecord::Migration[5.0]
  def change
    add_column :registrations, :coupon, :string
  end
end
