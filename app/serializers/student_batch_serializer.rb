class StudentBatchSerializer < ActiveModel::Serializer
  attributes :id, :student, :batch, :status

  def batch
    BatchSerializer.new(object.batch)
  end

  def student
    UserSerializer.new(object.student)
  end
end
