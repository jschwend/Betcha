class GameLinesController < ApplicationController
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
       @game_lines = GameLine.find :all, 
                                   :include => {:game => :away_team}, 
                                   :conditions => "games.season=" + session[:season].to_s + " and games.wk=" + session[:week].to_s, 
                                   :order => "teams.school_nm, game_lines.load_dt DESC"
    end     
    
  end

  def show
	setup
    @game_line = GameLine.find(params[:id])
  end

  def new
	setup
    @game_line = GameLine.new
    @game_line.vig = -110
    @games = Game.find(:all, :conditions => "season=" + session[:season].to_s + " and wk=" + session[:week].to_s).sort do |a,b| a.away_team.school_nm <=> b.away_team.school_nm end
    @sportsbooks = Sportsbook.find(:all).sort do |a,b| a["sportsbook_nm"] <=> b["sportsbook_nm"] end
  end

  def create
	setup
    @game_line = GameLine.new(params[:game_line])
    if @game_line.save
      flash[:notice] = 'GameLine was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
	setup
    @game_line = GameLine.find(params[:id])
  end

  def update
	setup
    @game_line = GameLine.find(params[:id])
    if @game_line.update_attributes(params[:game_line])
      flash[:notice] = 'GameLine was successfully updated.'
      redirect_to :action => 'list'
    else
      render :action => 'edit'
    end
  end

  def destroy
	setup
    GameLine.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
