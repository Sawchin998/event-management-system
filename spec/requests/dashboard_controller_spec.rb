require "rails_helper"

RSpec.describe DashboardController, type: :request do
  describe "GET #index" do
    let(:params) { {} }
    subject(:dashboard_index) { get root_path, params: }

    context "when user is authenticated" do
      let(:user) { create(:user) }
      let(:event) { create(:event) }
      let!(:upcoming_event) { create(:event, date: Date.tomorrow) }

      before { create(:registration, user_id: user.id, event_id: event.id) }

      before do
        sign_in user
      end

      it "returns successful response" do
        dashboard_index

        expect(response).to have_http_status(:success)
      end

      it "assigns upcoming events" do
        dashboard_index

        expect(controller.instance_variable_get(:@upcoming_events)).to include(upcoming_event)
      end

      it "assigns registered events" do
        dashboard_index

        expect(controller.instance_variable_get(:@registered_events)).to include(event)
      end

      context "when the event is searched by title" do
        let!(:event1) { create(:event, title: "Search Event 1") }
        let!(:event2) { create(:event, title: "Event 2") }
        let(:params) { { search_by_title: "search" } }

        it "filters events by searched title keyword", :aggregate_failures do
          dashboard_index

          expect(controller.instance_variable_get(:@events)).to include(event1)
          expect(controller.instance_variable_get(:@events)).not_to include(event2)
        end
      end

      context "when the event is filtered by category" do
        let!(:event1) { create(:event, category: :sports) }
        let!(:event2) { create(:event, category: :business) }
        let(:params) { { category: :sports } }

        it "filters events by searched location keyword", :aggregate_failures do
          dashboard_index

          expect(controller.instance_variable_get(:@events)).to include(event1)
          expect(controller.instance_variable_get(:@events)).not_to include(event2)
        end
      end

      context "when the event is searched by location" do
        let!(:event1) { create(:event, location: "kathmandu") }
        let!(:event2) { create(:event, location: "lalitpur") }
        let(:params) { { location: "lalitpur"} }

        it "filters events by category", :aggregate_failures do
          dashboard_index

          expect(controller.instance_variable_get(:@events)).to include(event2)
          expect(controller.instance_variable_get(:@events)).not_to include(event1)
        end
      end
    end

    context "when user is not authenticated" do
      it "redirects to the sign-in page" do
        dashboard_index

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
