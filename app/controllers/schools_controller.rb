class SchoolsController < ApplicationController
  include SchoolsHelper

  before_action :validate_admin!, except: %i[show edit update]
  before_action :set_school, only: %i[ show edit update destroy ]

  def index
    @schools = School.all
  end

  def new
    @school = School.new
    @address = @school.build_address
  end

  def create
    @school = School.new(school_params)
    onboard_school
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
  end

  def update
    respond_to do |format|
      if @school.update(school_params)
        format.html { redirect_to school_url(@school), notice: "School was successfully updated." }
        format.json { render :show, status: :ok, location: @school }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @school.errors, status: :unprocessable_entity }
      end
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

  def user_params
    params[:school][:user][:password] = "test123"
    params[:school][:user].permit(:name, :email, :phone, :password)
  end

  def set_school
    @school = School.find(params[:id])
  end
end
