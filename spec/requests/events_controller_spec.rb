require 'rails_helper'

RSpec.describe EventsController, type: :request do
  describe 'GET #index' do
    it 'returns a found response' do
      get events_path

      expect(response).to have_http_status(:found)
    end
  end

  describe 'GET #new' do
    context 'when user is authenticated' do
      let(:user) { create(:user) }

      before do
        sign_in user
      end

      it 'returns a ok response' do
        get new_event_path

        expect(response).to have_http_status(:ok)
      end
    end

    context 'when user is not authenticated' do
      it 'redirects to the sign-in page' do
        get new_event_path

        expect(response).to redirect_to(new_user_session_path)
      end

      it 'returns a found response' do
        get new_event_path

        expect(response).to have_http_status(:found)
      end
    end
  end

  describe 'POST #create' do
    let!(:user) { create(:user) }
    let(:params) { { event: { user_id: user.id, title: "title", category: :sports, location: "kathmandu", date: 2.days.after } } }
    subject(:create_events) { post events_path, params: }

    context "when user is authenticated" do
      before do
        sign_in user
      end

      context "when the event save is successful" do
        it "creates a new event" do
          expect { create_events }.to change { Event.count }.by(1)
        end

        it "flashes 'Event was successfully created.' notice" do
          create_events

          expect(flash[:notice]).to eq("Event was successfully created.")
        end

        it "redirects to event index path" do
          create_events

          expect(response).to redirect_to(events_path)
        end

        it "returns the found response" do
          create_events

          expect(response).to have_http_status(:found)
        end
      end

      context "when the event save is not successful" do
        let(:user) { build(:user) }

        it "does not create a new event" do
          expect { create_events }.to change { Event.count }.by(0)
        end

        it "returns the ok response" do
          create_events

          expect(response).to have_http_status(:ok)
        end
      end
    end

    context "when user is not authenticated" do
      it "redirects to the sign-in page" do
        create_events

        expect(response).to redirect_to(new_user_session_path)
      end

      it 'returns a found response' do
        create_events

        expect(response).to have_http_status(:found)
      end
    end
  end

  describe 'GET #show' do
    let(:event) { create(:event) }

    it 'returns a found response' do
      get event_path(event)

      expect(response).to have_http_status(:found)
    end
  end

  describe 'GET #edit' do
    let(:user) { create(:user) }
    let(:another_user) { create(:user) }
    let(:event) { create(:event, creator: user) }

    context 'when user is authenticated' do
      context "when the user is the event creator" do
        before do
          sign_in user
        end

        it 'returns a found response' do
          get edit_event_path(event)

          expect(response).to have_http_status(:success)
        end
      end

      context "when the user is not the event creator" do
        before do
          sign_in another_user
        end

        it "redirects to the root path" do
          get edit_event_path(event)

          expect(response).to redirect_to(root_path)
        end

        it "flashes 'You are not authorized to perform this action.' alert" do
          get edit_event_path(event)

          expect(flash[:alert]).to eq('You are not authorized to perform this action.')
        end

        it "returns a found response" do
          get edit_event_path(event)

          expect(response).to have_http_status(:found)
        end
      end
    end

    context "when user is not authenticated" do
      it "redirects to the sign-in page" do
        get edit_event_path(event)

        expect(response).to redirect_to(new_user_session_path)
      end

      it 'returns a found response' do
        get edit_event_path(event)

        expect(response).to have_http_status(:found)
      end
    end
  end

  describe 'PATCH #update' do
    let(:user) { create(:user) }
    let(:another_user) { create(:user) }
    let(:event) { create(:event, user_id: user.id) }
    let(:params) { { event: { category: :social, location: "lalitpur" } } }
    subject(:update_events) { patch event_path(event), params: }

    context "when user is authenticated" do
      context "when the user is the event creator" do
        before do
          sign_in user
        end

        context "when the event update is successful" do
          it "updates the event", :aggregate_failure do
            update_events

            expect(event.reload.location).to eq("lalitpur")
            expect(event.reload.category).to eq("social")
          end

          it "flashes 'Event was successfully updated.' notice" do
            update_events

            expect(flash[:notice]).to eq("Event was successfully updated.")
          end

          it "redirects to event index path" do
            update_events

            expect(response).to redirect_to(events_path)
          end

          it "returns the found response" do
            update_events

            expect(response).to have_http_status(:found)
          end
        end

        context "when the event update is not successful" do
          before { allow_any_instance_of(Event).to receive(:update).and_return(false) }

          it "does not update the event", :aggregate_failure do
            update_events

            expect(event.reload.location).to_not eq("lalitpur")
            expect(event.reload.category).to_not eq("social")
          end

          it "returns the ok response" do
            update_events

            expect(response).to have_http_status(:ok)
          end
        end
      end

      context "when the user is not the event creator" do
        before do
          sign_in another_user
        end

        it "redirects to the root path" do
          update_events

          expect(response).to redirect_to(root_path)
        end

        it "flashes 'You are not authorized to perform this action.' alert" do
          update_events

          expect(flash[:alert]).to eq('You are not authorized to perform this action.')
        end

        it "returns a found response" do
          update_events

          expect(response).to have_http_status(:found)
        end
      end
    end

    context "when user is not authenticated" do
      it "redirects to the sign-in page" do
        update_events

        expect(response).to redirect_to(new_user_session_path)
      end

      it 'returns a found response' do
        update_events

        expect(response).to have_http_status(:found)
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:user) { create(:user) }
    let(:another_user) { create(:user) }
    let!(:event) { create(:event, creator: user) }
    subject(:event_destroy) { delete event_path(event) }

    context "when user is authenticated" do
      context "when the user is the event creator" do
        before do
          sign_in user
        end

        it 'destroys the event' do
          expect { event_destroy }.to change { Event.count }.by(-1)
        end

        it "flashes 'Event was successfully destroyed.' notice" do
          event_destroy

          expect(flash[:notice]).to eq("Event was successfully destroyed.")
        end

        it "redirects to event index path" do
          event_destroy

          expect(response).to redirect_to(events_path)
        end

        it "returns the found response" do
          event_destroy

          expect(response).to have_http_status(:found)
        end
      end

      context "when the user is not the event creator" do
        before do
          sign_in another_user
        end

        it "redirects to the root path" do
          event_destroy

          expect(response).to redirect_to(root_path)
        end

        it "flashes 'You are not authorized to perform this action.' alert" do
          event_destroy

          expect(flash[:alert]).to eq('You are not authorized to perform this action.')
        end

        it "returns a found response" do
          event_destroy

          expect(response).to have_http_status(:found)
        end
      end
    end

    context "when user is not authenticated" do
      it "redirects to the sign-in page" do
        event_destroy

        expect(response).to redirect_to(new_user_session_path)
      end

      it 'returns a found response' do
        event_destroy

        expect(response).to have_http_status(:found)
      end
    end
  end
end
