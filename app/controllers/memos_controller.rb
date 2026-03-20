# frozen_string_literal: true

class MemosController < ApplicationController
  before_action :authenticate_user!

  def index; end
end
