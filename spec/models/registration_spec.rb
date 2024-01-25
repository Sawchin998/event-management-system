require 'rails_helper'

RSpec.describe Registration, type: :model do
  describe "validations" do
    let(:user) { create(:user) }
    let(:event) { create(:event) }
    subject(:registration) { build(:registration, user_id: user.id, event_id: event.id) }

    context "when the attributes are valid" do
      it "is valid" do
        expect(registration).to be_valid
      end

      it "saves the registration" do
        registration.save!
      end
    end

    context "when the attributes are not valid" do
      context "when user_id is not present" do
        let(:error_message) { "Validation failed: User must exist" }
        let(:user) { build(:user) }

        it "is invalid" do
          expect { registration.save! }.to raise_error(ActiveRecord::RecordInvalid, error_message)
        end
      end

      context "when event_id is not present" do
        let(:error_message) { "Validation failed: Event must exist" }
        let(:event) { build(:event) }

        it "is invalid" do
          expect { registration.save! }.to raise_error(ActiveRecord::RecordInvalid, error_message)
        end
      end
    end
  end
end
