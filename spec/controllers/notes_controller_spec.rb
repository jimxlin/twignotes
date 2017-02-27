require 'rails_helper'

RSpec.describe NotesController, type: :controller do
  describe "notes#index action" do
    it "should list the notes in the db" do
      note1 = FactoryGirl.create(:note)
      note2 = FactoryGirl.create(:note, user: note1.user)
      sign_in note1.user
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
end
