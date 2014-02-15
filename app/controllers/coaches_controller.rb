class CoachesController < ApplicationController

  before_filter :authenticate_person!
  before_action :check_same_person, except: [:index, :new, :create, :show ]

  def index
    @coaches = Coach.all
  end

  def new
    @coach = Coach.new
  end

  def create
    @coach = Coach.new(coaches)
    if @coach.save
      redirect_to coaches_path, notice: 'New coach successfully registered!'
    else
      render action: "new"
    end
  end

  def edit
    @coach = Coach.find(params[:id])
  end

  def update
    @coach = Coach.find(params[:id])
    @coach.update_attributes coaches
    redirect_to coach_path, notice: 'coach information updated!'
  end

  def show
    @coach = Coach.find(params[:id])
  end

  def coaches
    params.require(:coach).permit(:first_name, :last_name, :email, :group_id, :picture, :twitter)
  end

  private
  def check_same_person
    redirect_to root_path, notice: 'You are not allowed to view this page' unless current_person.id == params[:id].to_i
  end

end
