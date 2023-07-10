require 'rails_helper'

RSpec.describe Course, type: :model do
  let(:stubbed_course) { build_stubbed(:course, school: build(:school)) }

  describe '#Course model attributes' do
    it { is_expected.to have_db_column(:title).of_type(:string) }
    it { is_expected.to have_db_column(:description).of_type(:text) }
    it { is_expected.to have_db_column(:school_id).of_type(:integer) }
  end

  describe '#active_record validations' do
    context '#title' do
      it { expect(stubbed_course).to validate_presence_of(:title) }
    end

    context '#description' do
      it { expect(stubbed_course).to validate_presence_of(:description) }
    end
  end

  describe '#Course belong_to active_record associations' do
    it { expect(stubbed_course).to belong_to(:school) }
  end

  describe '#Course has_many active_record associations' do
    it { should have_many(:batches).dependent(:destroy) }
  end
end
