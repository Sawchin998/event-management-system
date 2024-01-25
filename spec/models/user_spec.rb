require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do
    let(:name) { "name123"}
    let(:email) { "email123@email.com" }
    subject(:user) { build(:user, name:, email:) }

    context "when the attributes are valid" do
      it "is valid" do
        expect(user).to be_valid
      end

      it "saves the user" do
        user.save!
      end
    end

    context "when the attributes are not valid" do
      context "when email is not present" do
        let(:email) { nil }
        let(:error_message) { "Validation failed: Email can't be blank" }

        it "is invalid" do
          expect { user.save! }.to raise_error(ActiveRecord::RecordInvalid, error_message)
        end
      end

      context "when the name is not present" do
        let(:name) { nil }
        let(:error_message) { "Validation failed: Name can't be blank" }

        it "is invalid" do
          expect { user.save! }.to raise_error(ActiveRecord::RecordInvalid, error_message)
        end
      end

      context "when email is not valid" do
        let(:email) { "invalid_email" }
        let(:error_message) { "Validation failed: Email is invalid" }

        it "is invalid" do
          expect { user.save! }.to raise_error(ActiveRecord::RecordInvalid, error_message)
        end
      end
    end
  end
end
