require "rails_helper"

RSpec.describe CharactersController do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/characters").to route_to("characters#index")
    end
  end
end
