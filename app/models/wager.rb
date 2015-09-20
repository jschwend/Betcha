class Wager < ActiveRecord::Base
  self.primary_key = 'wager_id'
  belongs_to :game_line
  belongs_to :account
  
  @@defaultAccount = 2
  @@defaultAmount = 20
  
  def getDefaultAccount
  	@@defaultAccount
  end
  def getDefaultAmount
  	@@defaultAmount
  end
  
end
