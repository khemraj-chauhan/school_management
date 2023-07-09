module StudentBatchesHelper
  def add_stundent_on_batch
    ActiveRecord::Base.transaction do
      student_id = params[:student_batch][:student_id]
      student_id.blank? ? new_student : existing_student(student_id)
    end
  end

  private

  def user_params
    params[:student_batch][:password] = "test123"
    params.require(:student_batch).permit(:name, :email, :phone, :password)
  end

  def new_student
    student = User.create!(user_params)
    student_role = Role.find_by_name("student")
    UserRole.create!(role_id: student_role.id, user_id: student.id)
    @student_batch.update!(student_id: student.id)
  end

  def existing_student(student_id)
    student = User.find(student_id)
    student_batche = student.student_batches.find_by(batch_id: @student_batch.batch_id)
    return if student_batche.present?

    @student_batch.update!(student_id: student.id)
  end
end
