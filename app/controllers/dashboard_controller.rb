class DashboardController < ApplicationController
  before_action :authenticate_user!

  # index
  def index
    @upcoming_events = Event.where("date >= ?", Date.today)
                            .order(date: :asc)
    @registered_events = current_user.registered_events

    @events = Event.all
    @events = @events.search_by_title(params[:search_by_title]) if params[:search_by_title].present?
    @events = @events.where(category: params[:category]) if params[:category].present?
    @events = @events.where(location: params[:location]) if params[:location].present?
  end
end
