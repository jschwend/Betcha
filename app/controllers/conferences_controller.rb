class ConferencesController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  def list
      @conferences = Conference.find :all,
                           			 :order => "conferences.conference_nm"
  end

  def show
    @conference = Conference.find(params[:id])
    @teams = Team.find(:all, :conditions => "conference_id = '#{@conference.id}'").sort do |a,b| a["school_nm"] <=> b["school_nm"] end
  end

  def new
    @conference = Conference.new
  end

  def create
    @conference = Conference.new(params[:conference])
    if @conference.save
      flash[:notice] = 'Conference was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @conference = Conference.find(params[:id])
  end

  def update
    @conference = Conference.find(params[:id])
    if @conference.update_attributes(params[:conference])
      flash[:notice] = 'Conference was successfully updated.'
      redirect_to :action => 'show', :id => @conference
    else
      render :action => 'edit'
    end
  end

  def destroy
    Conference.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
