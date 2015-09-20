class GamesController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  #verify :method => :post, :only => [ :destroy, :create, :update ],
  #       :redirect_to => { :action => :list }

  def setup
    if !session[:season].nil? and !session[:week].nil?
      $season = Integer(session[:season])
      $week = Integer(session[:week])
    end
  end
  
  def list
    setup
      
    if !session[:season].nil? and !session[:week].nil?
       @games = Game.includes(:away_team)\
                    .where("season=? and wk=?", session[:season].to_s, session[:week].to_s)\
                    .order("games.game_time, teams.school_nm")
    else
       @games = Game.includes(:away_team)\
                    .where("season=? and wk=?", "2012", "7")\
                    .order("games.season, games.wk, games.game_time, teams.school_nm")
    end
  end

  def show
    setup
    @game = Game.find(params[:id])
    @nextGame = Game.find(:first, :conditions => [ "wk = ? AND game_id > ?", @game.wk, @game.game_id ])
  end

  def new
    setup
    @game = Game.new
    @game.season = session[:season]
    @game.wk = session[:week]
    @teams = Team.find(:all).sort do |a,b| a["school_nm"] <=> b["school_nm"] end
    @sportsbooks = Sportsbook.find(:all).sort do |a,b| a["sportsbook_nm"] <=> b["sportsbook_nm"] end
    a = 0;
    @sportsbooks.each {|s|
      @game.game_lines[a] = GameLine.new
      @game.game_lines[a].sportsbook_id = s.sportsbook_id
      @game.game_lines[a].sportsbook = s
      @game.game_lines[a].vig = 110
      a += 1
    }
  end

  def create
    setup
    @game = Game.new(params[:game])
    if @game.save
      logger.info('Game saved, looping through lines....')
      @lines = params[:game_lines_count].to_i
      logger.info('Processing ' + @lines.to_s + ' lines')
      for a in (0..@lines -= 1)
        logger.info('Processing line ' + a.to_s)
        @gameLine = GameLine.new(params['game_line' + a.to_s])
        if !@gameLine.vig.nil? and !@gameLine.home_spread.nil?
          @gameLine.game_id = @game.game_id
          @gameLine.save
          logger.info('Game line ' + a.to_s + ' saved')
        end
      end
      flash[:notice] = 'Game was successfully created.'
      session[:season] = @game.season
      session[:week] = @game.wk
      redirect_to :action => 'new'
    else
      render :action => 'new'
    end
  end

  def edit
    setup
    @game = Game.find(params[:id])
    @teams = Team.find(:all).sort do |a,b| a["school_nm"] <=> b["school_nm"] end
  end

  def update
    setup
    @game = Game.find(params[:id])
    if @game.update_attributes(params[:game])
      flash[:notice] = 'Game was successfully updated.'
      redirect_to :action => 'list'
    else
      render :action => 'edit'
    end
  end

  def destroy
    setup
    Game.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
