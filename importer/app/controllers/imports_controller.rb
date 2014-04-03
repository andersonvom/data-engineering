class ImportsController < ApplicationController

  def index
    @import = Import.new
  end

end
