class Team < ActiveRecord::Base
  self.primary_key = 'team_id'
  belongs_to :conference
  has_many :away_games, :class_name => "Game", :foreign_key => "away_team_id"
  has_many :home_games, :class_name => "Game", :foreign_key => "home_team_id"
  has_many :ranks, :class_name => "Rank"
  
  @@Stats = Array.new
  @@Season = 0
  @@Weeek = 0
  
  @@weeksToAverage = 6
  def getWeeksToAverage
  	@@weeksToAverage
  end
  
  def getRankFactor(season,wk)
  	currRank = ranks.find(:first, :conditions => 'wk = ' + wk.to_s + ' and season = ' + season.to_s) 
	if (currRank.nil?)
	   1.0
	else
	   1.0+(1.0/currRank.rank).round(2)
	end
  end
  
  def getRank(season,wk)
  	currRank = ranks.find(:first, :conditions => 'wk = ' + wk.to_s + ' and season = ' + season.to_s) 
	if (currRank.nil?)
	   "NR"
	else
	   currRank.rank
	end
  end
  def loadStats(season,wk)
    if ((@@Season == season) && (@@Week == wk))
       return @@Stats
    end
    stats = Stat.run_sproc("call GetStats("+season.to_s+","+(wk.to_i-1).to_s+")")
    results = Array.new
    i = 0
    stats.each do |s| 
	   	results[i] = Stat.new(s)
	   	i = i + 1
	end
	@@Season = season
	@@Week = wk
	@@Stats = results
  end
  def getMyRank(season,wk,showDets)
    currRank = "NR"
    stats = loadStats(season,wk)
    stats.each do |stat| 
		if (stat.school_nm == self.school_nm)
		   currRank = stat.MyRank.to_s
		   if (showDets) 
		   	currRank += " (oy:"+stat.oyards_rank.to_s + " op:" +stat.opts_rank.to_s+ " dy:"+stat.dyards_rank.to_s + " dp:" +stat.dpts_rank.to_s+")"
		   end
		end
	end
	currRank
  end
  
  def getRankHTML(season,wk)
  	currRank = ranks.find(:first, :conditions => 'wk = ' + wk.to_s + ' and season = ' + season.to_s) 
	if (currRank.nil?)
	   ""
	else
	   "<b>" + currRank.rank.to_s + "</b>".html_safe
	end
  end  
  def getAvgOppMyRank(season,wk)
    stats = loadStats(season,wk)
    sum   = 0.0
    count = 0
    away_games.each do |g| 
       if !g.away_score.nil? and !g.home_score.nil? and g.season == $season
       	oppRank = 9999
			stats.each do |stat| 
				if (stat.school_nm == g.home_team.school_nm)
				   oppRank = stat.MyRank
				end
			end
		   
		  if (oppRank != 9999)
			 sum = sum + oppRank
             count = count + 1
		  end
       end
    end
    home_games.each do |g| 
       if !g.away_score.nil? and !g.home_score.nil? and g.season == $season
       	oppRank = 9999
			stats.each do |stat| 
				if (stat.school_nm == g.away_team.school_nm)
				   oppRank = stat.MyRank
				end
			end
		  if (oppRank != 9999)
			 sum = sum + oppRank
             count = count + 1
		  end
       end
    end
    if (count > 0)
    	(sum / count).round(2)
    end
  end
  
  def getRecord
    wins = 0
    losses = 0
    away_games.each do |g| 
                       if !g.away_score.nil? and !g.home_score.nil? and g.season == $season
                          if g.away_score > g.home_score
                             wins += 1
                          else
                             losses += 1
                          end 
                       end
                    end
    home_games.each do |g| 
                       if !g.away_score.nil? and !g.home_score.nil? and g.season == $season
                          if g.away_score > g.home_score
                             losses += 1
                          else
                             wins += 1
                          end
                       end
                    end
    '<font color="green">' + wins.to_s + '</font>-<font color="red">' + losses.to_s + '</font>'.html_safe
  end
  
  
  def getRecordATS
    wins = 0
    losses = 0
    pushes = 0
    away_games.each do |g| 
                       prevBook = 0
                       g.game_lines.each do |gl| 
                 				if gl.sportsbook.sportsbook_id != prevBook
                                            if !g.away_score.nil? and !g.home_score.nil? and g.season == $season
                                               if g.away_score > (g.home_score + gl.home_spread)
                                                  wins += 1
                                               end
                                               if g.away_score < (g.home_score + gl.home_spread)
                                                  losses += 1
                                               end 
                                               if g.away_score == (g.home_score + gl.home_spread)
                                                  pushes += 1
                                               end 
                                            end 
                                         end
                                         prevBook = gl.sportsbook.sportsbook_id 
                                 end
                    end
    home_games.each do |g| 
                       prevBook = 0
                       g.game_lines.each do |gl| 
                 				if gl.sportsbook.sportsbook_id != prevBook
                                            if !g.away_score.nil? and !g.home_score.nil? and g.season == $season
                                               if g.away_score > (g.home_score + gl.home_spread)
                                                  losses += 1
                                               end
                                               if g.away_score < (g.home_score + gl.home_spread)
                                                  wins += 1
                                               end 
                                               if g.away_score == (g.home_score + gl.home_spread)
                                                  pushes += 1
                                               end 
                                            end 
                                         end
                                         prevBook = gl.sportsbook.sportsbook_id 
                                 end
                    end
    '<font color="green">' + wins.to_s + '</font>-<font color="red">' + losses.to_s + '</font>-<font color="blue">' + pushes.to_s + '</font>'.html_safe
  end
  
  
  def getPtsPerGame
    fPts  = 0.0
    aPts  = 0.0
    games = 0
    away_games.each do |g| 
    	if !g.away_score.nil? and !g.home_score.nil? and g.season == $season
        	games += 1
        	fPts += g.away_score
        	aPts += g.home_score
	    end
    end
    home_games.each do |g| 
    	if !g.away_score.nil? and !g.home_score.nil? and g.season == $season
        	games += 1
        	fPts += g.home_score
        	aPts += g.away_score
	    end
    end
    if games != 0
		fPts = (fPts / games).round(1)
		aPts = (aPts / games).round(1)
    end
    '<font color="green">' + fPts.to_s + '</font>-<font color="red">' + aPts.to_s + '</font>'.html_safe
  end
  
  
  def getPtsPerGameWk(wk)
    fPts  = 0.0
    aPts  = 0.0
    games = 0
    away_games.each do |g| 
    	if !g.away_score.nil? and !g.home_score.nil?  and g.season == $season and g.wk < wk and g.wk >= (wk - @@weeksToAverage)
        	games += 1
        	fPts += g.away_score
        	aPts += g.home_score
	    end
    end
    home_games.each do |g| 
    	if !g.away_score.nil? and !g.home_score.nil? and g.season == $season and g.wk < wk and g.wk >= (wk - @@weeksToAverage)
        	games += 1
        	fPts += g.home_score
        	aPts += g.away_score
	    end
    end
    if games != 0
		fPts = (fPts / games).round(1)
		aPts = (aPts / games).round(1)
    end
    '<font color="green">' + fPts.to_s + '</font>-<font color="red">' + aPts.to_s + '</font>'.html_safe
  end
  
  
  def getAvgPtsFor(wk)
    fPts  = 0.0
    games = 0
    away_games.each do |g| 
    	if !g.away_score.nil? and !g.home_score.nil?  and g.season == $season and g.wk < wk and g.wk >= (wk - @@weeksToAverage)
        	games += 1
        	fPts += g.away_score
	    end
    end
    home_games.each do |g| 
    	if !g.away_score.nil? and !g.home_score.nil?  and g.season == $season and g.wk < wk and g.wk >= (wk - @@weeksToAverage)
        	games += 1
        	fPts += g.home_score
	    end
    end
    if games != 0
		fPts = (fPts / games).round(1)
    end
	fPts
  end
  
  
  def getAvgPtsAgainst(wk)
    aPts  = 0.0
    games = 0
    away_games.each do |g| 
    	if !g.away_score.nil? and !g.home_score.nil?  and g.season == $season and g.wk < wk and g.wk >= (wk - @@weeksToAverage)
        	games += 1
        	aPts += g.home_score
	    end
    end
    home_games.each do |g| 
    	if !g.away_score.nil? and !g.home_score.nil?  and g.season == $season and g.wk < wk and g.wk >= (wk - @@weeksToAverage)
        	games += 1
        	aPts += g.away_score
	    end
    end
    if games != 0
		aPts = (aPts / games).round(1)
    end
	aPts
  end
  
  
  def AvgPtsFor()
    fPts  = 0.0
    games = 0
    away_games.each do |g| 
    	if !g.away_score.nil? and !g.home_score.nil?  and g.season == $season
        	games += 1
        	fPts += g.away_score
	    end
    end
    home_games.each do |g| 
    	if !g.away_score.nil? and !g.home_score.nil?  and g.season == $season
        	games += 1
        	fPts += g.home_score
	    end
    end
    if games != 0
		fPts = (fPts / games).round(1)
    end
	fPts
  end

  def AvgPtsAgainst()
    aPts  = 0.0
    games = 0
    away_games.each do |g| 
    	if !g.away_score.nil? and !g.home_score.nil?  and g.season == $season
        	games += 1
        	aPts += g.home_score
	    end
    end
    home_games.each do |g| 
    	if !g.away_score.nil? and !g.home_score.nil?  and g.season == $season
        	games += 1
        	aPts += g.away_score
	    end
    end
    if games != 0
		aPts = (aPts / games).round(1)
    end
	aPts
  end
end
