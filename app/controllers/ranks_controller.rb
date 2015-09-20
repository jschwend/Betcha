class RanksController < ApplicationController
  def index
    list
    render :action => 'list'
  end
  def setup
    if !session[:season].nil? and !session[:week].nil?
      $season = Integer(session[:season])
      $week = Integer(session[:week])
    end
  end

  def list
	setup
    if !session[:season].nil? and !session[:week].nil?
       @ranks = Rank.find :all, 
                          :conditions => "season=" + session[:season].to_s + " and wk=" + session[:week].to_s, 
                          :order => "rank"
    else
       @ranks = Rank.find :all, 
                          :order => "season, wk, rank"
    end     
  end

  def show
	setup
    @rank = Rank.find(params[:id])
  end

  def new
	setup
    @rank = Rank.new
  end

  def create
	setup
    @rank = Rank.new(params[:rank])
    if @rank.save
      flash[:notice] = 'Rank was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
	setup
    @rank = Rank.find(params[:id])
  end

  def update
	setup
    @rank = Rank.find(params[:id])
    if @rank.update_attributes(params[:rank])
      flash[:notice] = 'Rank was successfully updated.'
      redirect_to :action => 'show', :id => @rank
    else
      render :action => 'edit'
    end
  end

  def destroy
	setup
    Rank.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
