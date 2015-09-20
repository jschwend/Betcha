class FramesController < ApplicationController
  def confList
    @conferences = Conference.find(:all).sort do |a,b| a["conference_nm"] <=> b["conference_nm"] end
  end
  def top25
	@season = Rank.find(:first, :conditions => 'season = (select max(season) from ranks)').season
  	if params[:wk] != nil
		@week = params[:wk].to_i
	else 
	    @week = Rank.find(:first, :conditions => 'season = ' + @season.to_s, :order => 'ranks.wk DESC').wk
	end
    @ranks = Rank.find(:all, :conditions => 'wk = ' + @week.to_s + ' and season = ' + @season.to_s).sort do |a,b| a["rank"] <=> b["rank"] end
  end
  def settings
    @season = session[:season]
    @week = session[:week]
  end
  def settingsSave
      session[:season] = params[:season]
      session[:week] = params[:week]
      $season = Integer(params[:season])
      $week = Integer(params[:week])
      redirect_to :action => 'settings'
  end
end