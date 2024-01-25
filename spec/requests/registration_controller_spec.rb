require "rails_helper"

RSpec.describe RegistrationsController, type: :request do
  describe "POST #create" do
    let!(:user) { create(:user) }
    let(:event) { create(:event) }
    let(:params) { { registration: { user_id: user.id, event_id: event.id } } }
    subject(:create_registrations) { post event_registrations_path(event), params: }

    context "when user is authenticated" do
      before do
        sign_in user
      end

      context "when the registration save is successful" do
        it "creates a new registration" do
          expect { create_registrations }.to change { Registration.count }.by(1)
        end

        it "flashes 'Registered successfully!' notice" do
          create_registrations

          expect(flash[:notice]).to eq("Registered successfully!")
        end

        it "redirects to root path" do
          create_registrations

          expect(response).to redirect_to(root_path)
        end

        it "returns the found response" do
          create_registrations

          expect(response).to have_http_status(:found)
        end
      end

      context "when the registration save is not successful" do
        let(:user) { build(:user) }

        it "does not create a new registration" do
          expect { create_registrations }.to change { Registration.count }.by(0)
        end

        it "flashes 'Registration unsuccessful' notice" do
          create_registrations

          expect(flash[:notice]).to eq("Registration unsuccessful")
        end

        it "redirects to root path" do
          create_registrations

          expect(response).to redirect_to(root_path)
        end

        it "returns the found response" do
          create_registrations

          expect(response).to have_http_status(:found)
        end
      end
    end

    context "when user is not authenticated" do
      it "redirects to the sign-in page" do
        create_registrations

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
