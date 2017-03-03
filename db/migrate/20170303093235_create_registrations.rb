class CreateRegistrations < ActiveRecord::Migration[5.0]
  def change
    create_table :registrations do |t|
      t.references :plan, index: true
      t.string :email
      t.string :customer_id
      t.string :card_token
      t.date :end_date


      t.timestamps
    end
  end
end
