class ImportsController < ApplicationController

  def index
    @import = Import.new
    @imports = Import.all
  end

  def create
    @import = Import.new(import_params)
    @import.save
    redirect_to imports_path
  end

  private

  def import_params
    params.require(:import).permit(:file)
  end

end
