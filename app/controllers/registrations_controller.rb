class RegistrationsController < ApplicationController
  before_action :set_plan

  def new
    @registration = Registration.new
  end

  def create
    @registration = Registration.new(registration_params)
    raise "Please, check registration errors" unless @registration.valid?
    @registration.process_payment
    @registration.save
    flash[:notice] = 'Registration was successfully created.'
    # redirect_to @registration, notice: 'Registration was successfully created.'
  rescue Stripe::CardError => e
    flash[:error] = e.message
    render :new
  end

  private
    def registration_params
      params.require(:registration).permit(:plan_id).merge({
        email: stripe_params["stripeEmail"],
        card_token: stripe_params["stripeToken"],
        plan: @plan
      })
    end

    def stripe_params
      params.permit :stripeEmail, :stripeToken
    end

    def set_plan
      @plan = Plan.find(params[:plan_id])
    end
end
