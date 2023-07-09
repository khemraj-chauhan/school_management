class SchoolAdmin < ApplicationRecord
  belongs_to :school
  belongs_to :admin, class_name: "User", foreign_key: "admin_id"
end
