class SchoolsController < ApplicationController
  include SchoolsHelper

  before_action :validate_super_admin!, only: %i[ new create destroy ]
  before_action :validate_admin!, only: %i[ edit update ]
  before_action :set_school, only: %i[ show edit update destroy ]

  def index
    if current_user.admin?
      @schools = School.all
    elsif current_user.school_admin?
      @schools = current_user.schools
    elsif current_user.student?
      @schools = current_user.stundent_schools
    end

    respond_to do |format|
      format.html
      format.json { render json: @schools, each_serializer: SchoolSerializer, status: 200 }
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
      format.json { render json: @school, serializer: SchoolSerializer, status: :created }
    end
  rescue StandardError => exception
    flash[:error] = exception.message
    respond_to do |format|
      format.html { render :new, status: :unprocessable_entity}
      format.json { render json: {data: [], error: exception.message}, status: :unprocessable_entity }
    end
  end

  def show
    respond_to do |format|
      format.html
      format.json { render json: @school, serializer: SchoolSerializer, status: 200 }
    end
  end

  def edit
    @address = @school.address || @school.build_address
    @admins = @school.admins
  end

  def update
    modification
    respond_to do |format|
      format.html { redirect_to school_url(@school), notice: "School was successfully updated." }
      format.json { render json: @school, serializer: SchoolSerializer, status: :ok }
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
      format.json { render json: {data: [], message: "School was successfully destroyed."}, status: :ok }
    end
  end

  private

  def set_school
    @school = if current_user.admin?
      School.find(params[:id])
    elsif current_user.school_admin?
      current_user.schools.find(params[:id])
    elsif current_user.student?
      current_user.stundent_schools.find(params[:id])
    end
  end
end
