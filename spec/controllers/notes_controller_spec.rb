require 'rails_helper'

RSpec.describe NotesController, type: :controller do
  describe "notes#index" do
    it "should list the notes in the db" do
      user = FactoryGirl.create(:user)
      note1 = FactoryGirl.create(:note, user: user)
      note2 = FactoryGirl.create(:note, user: user)
      sign_in user
      get :index

      expect(response).to have_http_status :success
      json_resp = ActiveSupport::JSON.decode(@response.body)
      expect(json_resp.count).to eq(2)
      response_ids = json_resp.map { |note| note["id"] }
      expect(response_ids).to eq([note1.id, note2.id])
    end

    it "should return a nil json response if user is not signed in" do
      note1 = FactoryGirl.create(:note)
      note2 = FactoryGirl.create(:note)
      get :index

      json_resp = ActiveSupport::JSON.decode(@response.body)
      expect(json_resp).to be_nil
    end
  end

  describe "notes#creation" do
    it "should successfully create a new note in the db" do
      user = FactoryGirl.create(:user)
      sign_in user
      post :create, params: { note: { title: 'foo', body: 'bar' } }

      expect(response).to have_http_status(:success)
      expect(Note.last.title).to eq("foo")
      expect(Note.last.user).to eq(user)
    end

    it "should require users to be logged in" do
      post :create, params: { note: { title: 'foo', body: 'bar' } }
      expect(response).to redirect_to new_user_session_path
    end
  end

  describe "notes#update" do
    it "should allow changes to notes" do
      note = FactoryGirl.create(:note, title: "foo", body: "bar")
      sign_in note.user
      put :update, params: { id: note.id, note: { title: 'goo', body: 'car' } }

      expect(response).to have_http_status(:success)
      note.reload
      expect(note.title).to eq("goo")
      expect(note.body).to eq("car")
    end

    it "should require users to be logged in" do
      note = FactoryGirl.create(:note, title: "foo", body: "bar")
      put :update, params: { id: note.id, note: { title: 'goo', body: 'car' } }
      expect(response).to redirect_to new_user_session_path
    end
  end

  describe "notes#destroy" do
    it "should allow notes to be deleted" do
      note = FactoryGirl.create(:note)
      sign_in note.user
      delete :destroy, params: { id: note.id }

      expect(response).to have_http_status(:success)
      expect(Note.find_by_id(note.id)).to be_nil
    end

    it "should require users to be logged in" do
      note = FactoryGirl.create(:note)
      delete :destroy, params: { id: note.id }
      expect(response).to redirect_to new_user_session_path
    end
  end
end
