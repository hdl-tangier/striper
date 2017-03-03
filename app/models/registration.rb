class Registration < ApplicationRecord
  belongs_to :plan

  validates :email, presence: true
  validates :card_token, presence: true
  validates :plan, presence: true

  def process_payment
    customer = Stripe::Customer.create(
      email: email,
      source: card_token
    )

    Stripe::Charge.create(
      customer: customer.id,
      amount: plan.price,
      description: plan.name,
      currency: 'eur'
    )
  end
end
