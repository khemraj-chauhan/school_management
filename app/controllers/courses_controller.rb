class CoursesController < ApplicationController
  before_action :set_school
  before_action :set_course, only: %i[ show edit update destroy ]

  def index
    @courses = @school.courses
  end

  def new
    @school = School.find(params[:school_id])
    @course = @school.courses.new
  end

  def create
    @course = @school.courses.new(course_params)
    @course.save!
    respond_to do |format|
      format.html { redirect_to school_courses_path(@school), notice: "Course was successfully created." }
      format.json { render :show, status: :created, location: @course }
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
  end

  def update
    @course.update(course_params)
    respond_to do |format|
      format.html { redirect_to school_course_path, notice: "Course was successfully updated." }
      format.json { render :show, status: :ok, location: @course }
    end
  rescue StandardError => exception
    respond_to do |format|
      format.html { render :edit, status: :unprocessable_entity }
      format.json { render json: exception.message, status: :unprocessable_entity }
    end
  end

  def destroy
    @course.destroy

    respond_to do |format|
      format.html { redirect_to school_courses_url, notice: "Course was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_school
    @school = current_user.schools.find(params[:school_id])
  end

  def set_course
    @course = @school.courses.find(params[:id])
  end

  def course_params
    params.require(:course).permit(:title, :description)
  end
end
