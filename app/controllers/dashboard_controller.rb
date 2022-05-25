class DashboardController < ApplicationController
  skip_before_action :authenticate_doctor!, only: %i[terms privacy]

  def welcome
    @events = Event.order(created_at: :desc).last(10)
    @people = Person.order(created_at: :desc).last(10)
  end

  def terms
  end

  def privacy
  end
end
