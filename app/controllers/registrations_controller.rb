class RegistrationsController < ApplicationController
  before_action :set_plan, except: :hook

  def show
    @registration = Registration.find(params[:id])
  end

  def new
    @registration = Registration.new
  end

  def create
    @registration = Registration.new(registration_params)
    if @registration.save_with_payment
      redirect_to [@registration.plan, @registration], notice: "Thank you for subscribing to the #{@plan.name} plan!"
    else
      render :new
    end
  end

  protect_from_forgery except: :hook
  def hook
    event = Stripe::Event.retrieve(params["id"])

    case event.type
      when "invoice.payment_succeeded" #renew subscription
        Registration.find_by_customer_id(event.data.object.customer).renew
    end
    render status: :ok, json: "success"
  end

  private
    def registration_params
      params.require(:registration).permit(:plan_id, :coupon).merge({
        email: stripe_params["stripeEmail"],
        card_token: stripe_params["stripeToken"]
      })
    end

    def stripe_params
      params.permit :stripeEmail, :stripeToken
    end

    def set_plan
      @plan = Plan.find(params[:plan_id])
    end
end
