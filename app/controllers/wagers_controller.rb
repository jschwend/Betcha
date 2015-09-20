class WagersController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  def list
    if !session[:season].nil? and !session[:week].nil?
       @wagers = Wager.find :all, 
                            :include => {:game_line => {:game => :away_team}}, 
                            :conditions => "games.season=" + session[:season].to_s + " and games.wk=" + session[:week].to_s, 
                            :order => "account_id,teams.school_nm"
    else
       @wagers = Wager.find :all, 
                            :include => {:game_line => {:game => :away_team}}, 
                            :order => "season, wk, account_id,teams.school_nm"
    end     
  end

  def show
    @wager = Wager.find(params[:id])
  end

  def new
    @wager = Wager.new
    @game_lines = GameLine.find :all, :include => {:game => :away_team},
                                :conditions => "games.season=" + session[:season].to_s + " and games.wk=" + session[:week].to_s,
                                :order => "teams.school_nm"
    @accounts = Account.find(:all)
  end

  def create
    @wager = Wager.new(params[:wager])
    if @wager.save
      flash[:notice] = 'Wager was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def createAuto
    @wager = Wager.new
    @wager.account_id = @wager.getDefaultAccount
    @wager.amount = @wager.getDefaultAmount
    @wager.game_line_id = params[:wager_game_line_id]
    @wager.team = params[:wager_team]
    
    if @wager.save
      flash[:notice] = 'Wager was successfully created.'
      redirect_to :controller => 'games', :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @wager = Wager.find(params[:id])
    @game_lines = GameLine.find(:all, 
    							:conditions => "game_lines.game_id in (select game_id from games where season=" + session[:season] + " and wk=" + session[:week] + ")",
    							:include => {:game => :away_team},
    							:order => "teams.school_nm")
    @accounts = Account.find(:all)
  end

  def update
    @wager = Wager.find(params[:id])
    if @wager.update_attributes(params[:wager])
      flash[:notice] = 'Wager was successfully updated.'
      redirect_to :action => 'show', :id => @wager
    else
      render :action => 'edit'
    end
  end

  def destroy
    Wager.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
