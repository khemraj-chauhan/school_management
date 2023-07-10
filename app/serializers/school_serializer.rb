class SchoolSerializer < ActiveModel::Serializer
  attributes :id, :name, :address, :school_admin

  def address
    object.address&.full_address
  end

  def school_admin
    ActiveModel::Serializer::CollectionSerializer.new(object.admins, serializer: UserSerializer)
  end
end
