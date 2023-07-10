class CourseSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :school_name

  def school_name
    object.school.name
  end
end
