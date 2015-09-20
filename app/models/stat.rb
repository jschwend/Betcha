class Stat < ActiveRecord::Base
	attr_accessible :oyards_pg
	attr_accessible :opts_pg
	attr_accessible :dyards_pg
	attr_accessible :dpts_pg
	attr_accessible :oyards_rank
	attr_accessible :opts_rank
	attr_accessible :dyards_rank
	attr_accessible :dpts_rank
	attr_accessible :season
	attr_accessible :wk
	attr_accessible :school_nm
	attr_accessible :MyRank

	def oyards_pg=(f)
	  write_attribute(:oyards_pg, f.to_f)
	end
	def oyards_pg
	  read_attribute(:oyards_pg)
	end

	def opts_pg=(f)
	  write_attribute(:opts_pg, f.to_f)
	end
	def opts_pg
	  read_attribute(:opts_pg)
	end

	def dyards_pg=(f)
	  write_attribute(:dyards_pg, f.to_f)
	end
	def dyards_pg
	  read_attribute(:dyards_pg)
	end

	def dpts_pg=(f)
	  write_attribute(:dpts_pg, f.to_f)
	end
	def dpts_pg
	  read_attribute(:dpts_pg)
	end

	def oyards_rank=(i)
	  write_attribute(:oyards_rank, i.to_i)
	end
	def oyards_rank
	  read_attribute(:oyards_rank)
	end

	def opts_rank=(i)
	  write_attribute(:opts_rank, i.to_i)
	end
	def opts_rank
	  read_attribute(:opts_rank)
	end

	def dyards_rank=(i)
	  write_attribute(:dyards_rank, i.to_i)
	end
	def dyards_rank
	  read_attribute(:dyards_rank)
	end

	def dpts_rank=(i)
	  write_attribute(:dpts_rank, i.to_i)
	end
	def dpts_rank
	  read_attribute(:dpts_rank)
	end

	def season=(i)
	  write_attribute(:season, i.to_i)
	end
	def season
	  read_attribute(:season)
	end

	def wk=(i)
	  write_attribute(:wk, i.to_i)
	end
	def wk
	  read_attribute(:wk)
	end

	def school_nm=(s)
	  write_attribute(:school_nm, s.to_s)
	end
	def school_nm
	  read_attribute(:school_nm)
	end
	
	def MyRank=(i)
	  write_attribute(:MyRank, i.to_i)
	end
	def MyRank
	  read_attribute(:MyRank)
	end

  
  	def self.run_sproc(proc_name_with_parameters)
    	connection.select_all(proc_name_with_parameters)
	end
end
