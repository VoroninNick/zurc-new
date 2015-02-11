class HomeController < ApplicationController
  def index
    render template: 'page/index', layout: 'home'
  end
end
