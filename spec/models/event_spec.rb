# spec/models/event_spec.rb
require 'rails_helper'

RSpec.describe Event, type: :model do
  describe "validations" do
    let(:title) { "title987" }
    let(:category) { :sports }
    let(:location) { "kathmandu" }
    let(:date) { 10.days.after }
    subject(:event) { build(:event, title:, category:, location:, date:) }

    context "when the attributes are valid" do
      it "is valid" do
        expect(event).to be_valid
      end

      it "saves the event" do
        event.save!
      end
    end

    context "when the attributes are not valid" do
      context "when title is not present" do
        let(:title) { nil }
        let(:error_message) { "Validation failed: Title can't be blank" }

        it "is invalid" do
          expect { event.save! }.to raise_error(ActiveRecord::RecordInvalid, error_message)
        end
      end

      context "when category is not present" do
        let(:category) { nil }
        let(:error_message) { "Validation failed: Category can't be blank" }

        it "is invalid" do
          expect { event.save! }.to raise_error(ActiveRecord::RecordInvalid, error_message)
        end
      end

      context "when location is not present" do
        let(:location) { nil }
        let(:error_message) { "Validation failed: Location can't be blank" }

        it "is invalid" do
          expect { event.save! }.to raise_error(ActiveRecord::RecordInvalid, error_message)
        end
      end

      context "when date is not present" do
        let(:date) { nil }
        let(:error_message) { "Validation failed: Date can't be blank" }

        it "is invalid" do
          expect { event.save! }.to raise_error(ActiveRecord::RecordInvalid, error_message)
        end
      end
    end
  end

  describe 'scopes' do
    describe '.search_by_title' do
      let!(:event1) { create(:event, title: 'Sports Event 1') }

      it 'returns events that match the title' do
        expect(Event.search_by_title('Sports')).to include(event1)
      end

      it 'does not return events that do not match the title' do
        expect(Event.search_by_title('Education')).not_to include(event1)
      end
    end
  end
end
