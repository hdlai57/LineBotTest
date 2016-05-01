class ConvosController < ApplicationController
  def index
    @convos = Convo.all
  end

  def new
    @convo = Convo.new
  end

  def create
    convo = Convo.new(convo_params)
    if convo.save!
      redirect_to convos_path
    else
      render :new
    end
  end


  private

  def convo_params
    params.require(:convo).permit(:text)
  end

end