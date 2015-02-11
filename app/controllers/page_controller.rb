class PageController < ApplicationController
  def index
    render layout: 'home'
  end

  def contact
  end

  def about
  end

  def what_we_do
    @breadcrumbs = [
        { title: 'ЩО МИ РОБИМО' }
    ]
  end

  def custom_page
    render inline: params.inspect
  end
end
