class Registration < ApplicationRecord
  belongs_to :plan

  validates :email, presence: true
  validates :card_token, presence: true
  validates :plan, presence: true

  def process_payment
    customer_data = {
      email: email,
      source: card_token
    }.merge(plan: plan.name.downcase)

    customer = Stripe::Customer.create(customer_data)

    Stripe::Charge.create(
      customer: customer.id,
      amount: plan.price,
      description: plan.name,
      currency: 'eur'
    )

    self.customer_id = customer.id
  end

  def renew
    update_attribute :end_date, Date.today + 1.month
  end
end
