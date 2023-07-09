class SchoolsController < ApplicationController
  include SchoolsHelper

  before_action :validate_super_admin!, only: %i[ new create destroy ]
  before_action :validate_admin!, except: %i[ new create destroy ]
  before_action :set_school, only: %i[ show edit update destroy ]

  def index
    if current_user.admin?
      @schools = School.all
    elsif current_user.school_admin?
      @schools = current_user.schools
    end
  end

  def new
    @school = School.new
    @address = @school.build_address
  end

  def create
    @school = School.new(school_params)
    onboard
    respond_to do |format|
      format.html { redirect_to school_url(@school), notice: "School was successfully created." }
      format.json { render :show, status: :created, location: @school }
    end
  rescue StandardError => exception
    flash[:error] = exception.message
    respond_to do |format|
      format.html { render :new, status: :unprocessable_entity}
      format.json { render json: exception.message, status: :unprocessable_entity }
    end
  end

  def show
  end

  def edit
    @address = @school.address || @school.build_address
    @admins = @school.admins
  end

  def update
    modification
    respond_to do |format|
      format.html { redirect_to school_url(@school), notice: "School was successfully updated." }
      format.json { render :show, status: :ok, location: @school }
    end
  rescue StandardError => exception
    respond_to do |format|
      format.html { render :edit, status: :unprocessable_entity }
      format.json { render json: exception.message, status: :unprocessable_entity }
    end
  end

  def destroy
    @school.destroy

    respond_to do |format|
      format.html { redirect_to schools_url, notice: "School was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_school
    @school = current_user.admin? ? School.find(params[:id]) : current_user.schools.find(params[:id])
  end
end
