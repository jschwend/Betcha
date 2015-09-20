class Rank < ActiveRecord::Base
  self.primary_key = 'rank_id'
  belongs_to :team
end
