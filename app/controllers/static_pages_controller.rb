class StaticPagesController < ApplicationController
  def index
    # note creation modal
    @note = Note.new
  end
end
