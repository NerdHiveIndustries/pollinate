class HomeController < ApplicationController
  # GET /homes
  def index
    respond_to do |format|
      format.html # index.html.slim
    end
  end
end
