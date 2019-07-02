# frozen_string_literal: true

class HomeController < ApplicationController
  skip_before_action :login_required

  def index
  end

  def disclaimer
  end
end
