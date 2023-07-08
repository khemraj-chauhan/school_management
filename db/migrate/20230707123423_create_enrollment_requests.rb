class CreateEnrollmentRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :enrollment_requests do |t|
      t.integer :student_id
      t.integer :batch_id
      t.string :status

      t.timestamps
    end
  end
end
