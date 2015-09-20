class Game < ActiveRecord::Base
  self.primary_key = 'game_id'
  belongs_to :away_team, :class_name => "Team", :foreign_key => "away_team_id"  
  belongs_to :home_team, :class_name => "Team", :foreign_key => "home_team_id"  
  has_many :game_lines, :order => "load_dt DESC"
  
  def getLatestSpread(ret)
	id = 0
	rez = -999.9
    lines = game_lines.sort {|a,b| b.load_dt <=> a.load_dt}
    gl = lines.first
	if !gl.home_spread.nil?
    	if gl.home_spread > rez
        	rez = gl.home_spread
			id = gl.game_line_id
        end
    end
    if rez == -999.9
       rez = nil
    end
    if ret == 'id'
    	id
    else
        rez
    end
  end
  def getLatestOU(ret)
	id = 0
	rez = -999.9
    lines = game_lines.sort {|a,b| b.load_dt <=> a.load_dt}
    gl = lines.first
	if !gl.home_spread.nil?
    	if gl.home_spread > rez
        	rez = gl.over_under
			id = gl.game_line_id
        end
    end
    if rez == -999.9
       rez = nil
    end
    if ret == 'id'
    	id
    else
        rez
    end
  end
  
  def getMaxSpread(ret)
	id = 0
	rez = -999.9
    game_lines.each do |gl| 
    	if !gl.home_spread.nil?
        	if gl.home_spread > rez
            	rez = gl.home_spread
				id = gl.game_line_id
            end
        end
        if rez == -999.9
           rez = nil
        end
    end
    if ret == 'id'
    	id
    else
        rez
    end
  end
  
  def getMinSpread(ret)
	id = 0
    rez = 999.9
    game_lines.each do |gl| 
    	if !gl.home_spread.nil?
        	if gl.home_spread < rez
            	rez = gl.home_spread
				id = gl.game_line_id
            end
        end
        if rez == 999.9
           rez = nil
        end
    end
    if ret == 'id'
    	id
    else
        rez
    end
  end

  def getMaxOU(ret)
	id = 0
    rez = -999.9
    game_lines.each do |gl| 
    	if !gl.over_under.nil? and gl.over_under != 0.0
        	if gl.over_under > rez
            	rez = gl.over_under
				id = gl.game_line_id
            end
        end
        if rez == -999.9
           rez = 0.0
        end
    end
    if ret == 'id'
    	id
    else
        rez
    end
  end

  def getMinOU(ret)
	id = 0
    rez = 999.9
    game_lines.each do |gl| 
    	if !gl.over_under.nil? and gl.over_under != 0.0
        	if gl.over_under < rez
            	rez = gl.over_under
				id = gl.game_line_id
            end
        end
        if rez == 999.9
           rez = 0.0
        end
    end
    if ret == 'id'
    	id
    else
        rez
    end
  end
    
  def getLikelyTotal
	((home_team.getAvgPtsFor(wk) + 
	  away_team.getAvgPtsFor(wk) + 
      home_team.getAvgPtsAgainst(wk) + 
      away_team.getAvgPtsAgainst(wk)) / 2).round(2)
  end
  
  def getLikelyTotalAdjusted
  	homeAdj = 2.0 + (home_team.getAvgOppRankFactor(season,wk) - away_team.getRankFactor(season,wk))
  	awayAdj = 2.0 + (away_team.getAvgOppRankFactor(season,wk) - home_team.getRankFactor(season,wk))
	a = home_team.getAvgPtsFor(wk) * homeAdj 
	b = away_team.getAvgPtsFor(wk) * awayAdj 
    c = home_team.getAvgPtsAgainst(wk) / homeAdj 
    d = away_team.getAvgPtsAgainst(wk) / awayAdj
	((a + b + c + d) / 2).round(2)
  end
  
  def getLikelyHomeScore
	((home_team.getAvgPtsFor(wk) + away_team.getAvgPtsAgainst(wk)) / 2).round(2)
  end

  def getLikelyAwayScore
	((away_team.getAvgPtsFor(wk) + home_team.getAvgPtsAgainst(wk)) / 2).round(2)
  end

  def getLikelySpread1
	(getLikelyAwayScore - getLikelyHomeScore).round(2)
  end

  def getLikelySpread2
	(away_team.getAvgPtsFor(wk) - home_team.getAvgPtsFor(wk)).round(2)
  end

  def getLikelySpread3
	(home_team.getAvgPtsAgainst(wk) - away_team.getAvgPtsAgainst(wk)).round(2)
  end

end
  