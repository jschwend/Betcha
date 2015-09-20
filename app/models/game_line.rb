class GameLine < ActiveRecord::Base
  self.primary_key = 'game_line_id'
  belongs_to :game
  belongs_to :sportsbook
  
      
  def getProjection
  	a = ((over_under - home_spread.abs) / 2).round(0)
  	b = (a + home_spread.abs).round(0)
  	if (home_spread < 0.0)
  		proj = a.to_s + "-" + b.to_s
  	else
  		proj = b.to_s + "-" + a.to_s
  	end
	proj
  end
  
end
