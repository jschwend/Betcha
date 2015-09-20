class Sportsbook < ActiveRecord::Base
  self.primary_key = 'sportsbook_id'
  has_many :game_lines
end
