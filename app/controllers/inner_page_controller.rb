class InnerPageController < ApplicationController
  before_filter :init_breadcrumbs

  def init_breadcrumbs
    @breadcrumbs = []
  end
end
