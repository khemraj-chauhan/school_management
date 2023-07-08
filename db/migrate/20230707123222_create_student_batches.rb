class CreateStudentBatches < ActiveRecord::Migration[7.0]
  def change
    create_table :student_batches do |t|
      t.integer :student_id
      t.integer :batch_id
      t.string :status

      t.timestamps
    end
  end
end
