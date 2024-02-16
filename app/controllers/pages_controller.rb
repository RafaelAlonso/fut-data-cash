class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
    @teams = Team.all.order(name: :asc)
  end
end
