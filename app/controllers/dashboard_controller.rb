class DashboardController < ApplicationController
  skip_before_action :authenticate_doctor!, only: %i[terms privacy]

  def welcome
  end

  def terms
  end

  def privacy
  end
end
