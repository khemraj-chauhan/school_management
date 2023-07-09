class StudentBatch < ApplicationRecord
  belongs_to :student, class_name: "User", foreign_key: "student_id"
  belongs_to :batch

  enum status: { pending: "pending", approved: "approved", rejected: "rejected" }, _default: "pending"
end
