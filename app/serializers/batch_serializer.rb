class BatchSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :course

  def course
    CourseSerializer.new(object.course)
  end
end
