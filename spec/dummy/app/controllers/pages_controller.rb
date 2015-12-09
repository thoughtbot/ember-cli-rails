class PagesController < ApplicationController
  include HighVoltage::StaticPage

  before_filter :build_ember_app

  private

  def build_ember_app
    EmberCli.build(params[:ember_app])
  end
end
