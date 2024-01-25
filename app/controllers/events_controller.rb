class EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event, only: %i[show edit update destroy]
  before_action :authorize_user!, only: %i[edit update destroy]

  def index; end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params.merge(user_id: current_user.id))
    if @event.save
      redirect_to events_path, notice: 'Event was successfully created.'
    else
      render :new
    end
  end

  def show
    @registration = Registration.new
  end

  def edit; end

  def update
    if @event.update(event_params)
      redirect_to events_path, notice: 'Event was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @event.destroy
    redirect_to events_url, notice: 'Event was successfully destroyed.'
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:title, :date, :location, :description, :category)
  end

  def authorize_user!
    return if current_user == @event.creator

    redirect_to root_path, alert: 'You are not authorized to perform this action.'
  end
end
