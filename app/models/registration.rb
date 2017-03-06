class Registration < ApplicationRecord
  belongs_to :plan

  validates :email, presence: true
  validates :card_token, presence: true
  validates :plan, presence: true

  def save_with_payment
    if valid?
      customer_data = {
        email: email,
        source: card_token,
        coupon: coupon
      }.merge(plan: plan.name.downcase)

      customer = Stripe::Customer.create(customer_data)

      Stripe::Charge.create(
        customer: customer.id,
        amount: plan.price,
        description: plan.name,
        currency: 'eur'
      )

      self.customer_id = customer.id
      save!
    end
  rescue Stripe::CardError => e
    logger.error "Stripe error while creating customer: #{e.message}"
    errors.add :base, "There was a problem with your credit card."
    false
  end

  def renew
    update_attribute(:end_date, Date.today + 1.month)
  end
end
