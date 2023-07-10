class StudentBatchesController < ApplicationController
  include StudentBatchesHelper

  def new
    @student_batch = StudentBatch.new(batch_id: params[:batch_id])
  end

  def create
    @student_batch = add_stundent_on_batch
    respond_to do |format|
      format.html { redirect_to batch_path(@student_batch.batch, {course_id: @student_batch.batch.course.id}), notice: "Student was successfully added into the batch." }
      format.json { render json: @student_batch, serializer: StudentBatchSerializer, status: :created }
    end
  rescue StandardError => exception
    flash[:error] = exception.message
    respond_to do |format|
      format.html { render :new, status: :unprocessable_entity}
      format.json { render json: exception.message, status: :unprocessable_entity }
    end
  end

  def edit
    student_batch = StudentBatch.find(params[:id])
    params[:status].eql?("approved") ? student_batch.approved! : student_batch.rejected!

    respond_to do |format|
      format.html { redirect_to(request.referer) }
      format.json { render json: student_batch, serializer: StudentBatchSerializer, status: :ok }
    end
  end

  def enrollment_request
    student_batch = StudentBatch.create!(batch_id: params[:batch_id], student_id: current_user.id)

    respond_to do |format|
      format.html { redirect_to(request.referer) }
      format.json { render json: student_batch, serializer: StudentBatchSerializer, status: :created }
    end
  end
end
