class RegistrationsController < ApplicationController
  before_action :authenticate_user!

  def create
    @registration = Registration.new(registration_params)

    if @registration.save
      redirect_to root_path, notice: 'Registered successfully!'
    else
      redirect_to root_path, notice: 'Registration unsuccessful'
    end
  end

  private

  def registration_params
    params.require(:registration).permit(:user_id, :event_id)
  end
end
