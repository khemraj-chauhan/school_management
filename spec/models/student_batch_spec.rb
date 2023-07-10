require 'rails_helper'

RSpec.describe StudentBatch, type: :model do
  let(:stubbed_student_batch) { build_stubbed(:student_batch, student: build(:user), batch: build(:batch)) }

  describe '#StudentBatch model attributes' do
    it { is_expected.to have_db_column(:student_id).of_type(:integer) }
    it { is_expected.to have_db_column(:batch_id).of_type(:integer) }
    it { is_expected.to have_db_column(:status).of_type(:string) }
  end

  describe '#Course belong_to active_record associations' do
    it { expect(stubbed_student_batch).to belong_to(:student) }
    it { expect(stubbed_student_batch).to belong_to(:batch) }
  end

  describe '#Course enum for status column' do
    it { should define_enum_for(:status).with_values(pending: "pending", approved: "approved", rejected: "rejected").backed_by_column_of_type(:string) }
  end
end
