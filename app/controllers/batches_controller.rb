class BatchesController < ApplicationController
  before_action :validate_admin!, only: %i[ new create edit update destroy ]
  before_action :set_course
  before_action :set_batch, only: %i[ show edit update destroy ]

  def index
    @batches = @course.batches
  end

  def new
    @batch = @course.batches.new
  end

  def create
    @batch = Batch.new(batch_params)
    @batch.save!
    respond_to do |format|
      format.html { redirect_to batch_path(@batch, {course_id: @batch.course_id}), notice: "Batch was successfully created." }
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
    @batch.update(batch_params)

    respond_to do |format|
      format.html { redirect_to batch_path(@batch, {course_id: @batch.course_id}), notice: "Batch was successfully updated." }
      format.json { render :show, status: :ok, location: @batch }
    end
  rescue StandardError => exception
    respond_to do |format|
      format.html { render :edit, status: :unprocessable_entity }
      format.json { render json: exception.message, status: :unprocessable_entity }
    end
  end

  def destroy
    @batch.destroy

    respond_to do |format|
      format.html { redirect_to batches_path(course_id: @course.id), notice: "Batch was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_course
    if current_user.admin?
      @course = Course.find(params[:course_id])
    elsif current_user.school_admin?
      @course = current_user.courses.find(params[:course_id])
    elsif current_user.student?
      @course = current_user.stundent_courses.find(params[:course_id])
    end
  end

  def set_batch
    @batch = @course.batches.find(params[:id])
  end

  def batch_params
    params.require(:batch).permit(:name, :description, :course_id)
  end
end
