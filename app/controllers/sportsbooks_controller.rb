class SportsbooksController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  def list
    @sportsbooks = Sportsbook.find :all,
                                   :order => "sportsbooks.sportsbook_nm"
  end

  def show
    @sportsbook = Sportsbook.find(params[:id])
  end

  def new
    @sportsbook = Sportsbook.new
  end

  def create
    @sportsbook = Sportsbook.new(params[:sportsbook])
    if @sportsbook.save
      flash[:notice] = 'Sportsbook was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @sportsbook = Sportsbook.find(params[:id])
  end

  def update
    @sportsbook = Sportsbook.find(params[:id])
    if @sportsbook.update_attributes(params[:sportsbook])
      flash[:notice] = 'Sportsbook was successfully updated.'
      redirect_to :action => 'show', :id => @sportsbook
    else
      render :action => 'edit'
    end
  end

  def destroy
    Sportsbook.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
