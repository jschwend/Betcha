class TeamsController < ApplicationController
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
       myTeams1 = Team.find :all, 
                            :order => "school_nm"
       myTeams2 = myTeams1.sort {|a,b| (b.AvgPtsFor()/(b.AvgPtsAgainst()+0.01)).round(6).to_s + b.school_nm <=> (a.AvgPtsFor()/(a.AvgPtsAgainst()+0.01)).round(6).to_s + b.school_nm }
       @teams = myTeams2 
  end

  def show
	setup
    @team = Team.find(params[:id])
    if params[:disp] == "All"
	    @games = Game.find(:all, 
	                       :conditions => "home_team_id = '#{@team.id}' 
	                                    OR away_team_id = '#{@team.id}'").sort do |a,b| a["season"] + (a["wk"]/100) <=> b["season"] + (b["wk"]/100) end
    else
    	@games = Game.find(:all, 
    	                   :conditions => "(home_team_id = '#{@team.id}' 
    	                                 OR away_team_id = '#{@team.id}') 
    	                                and season = " + session[:season]).sort do |a,b| a["wk"] <=> b["wk"] end
    end
  end

  def new
	setup
    @team = Team.new
    @conferences = Conference.find(:all)
  end

  def create
	setup
    @team = Team.new(params[:team])
    if @team.save
      flash[:notice] = 'Team was successfully created.'
      redirect_to :action => 'new'
    else
      render :action => 'new'
    end
  end

  def edit
	setup
    @team = Team.find(params[:id])
    @conferences = Conference.find(:all)
  end

  def update
	setup
    @team = Team.find(params[:id])
    if @team.update_attributes(params[:team])
      flash[:notice] = 'Team was successfully updated.'
      redirect_to :action => 'list'
    else
      render :action => 'edit'
    end
  end

  def destroy
	setup
    Team.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
