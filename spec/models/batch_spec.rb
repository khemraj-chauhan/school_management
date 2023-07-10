require 'rails_helper'

RSpec.describe Batch, type: :model do
  let(:stubbed_batch) { build_stubbed(:batch) }

  describe '#Batch model attributes' do
    it { is_expected.to have_db_column(:name).of_type(:string) }
    it { is_expected.to have_db_column(:description).of_type(:text) }
    it { is_expected.to have_db_column(:course_id).of_type(:integer) }
  end

  describe '#active_record validations' do
    context '#name' do
      it { expect(stubbed_batch).to validate_presence_of(:name) }
    end

    context '#description' do
      it { expect(stubbed_batch).to validate_presence_of(:description) }
    end
  end

  describe '#Batch belong_to active_record associations' do
    it { expect(stubbed_batch).to belong_to(:course) }
  end

  describe '#Batch has_many active_record associations' do
    it { should have_many(:student_batches).dependent(:destroy) }
    it { should have_many(:students).through(:student_batches) }
  end
end
