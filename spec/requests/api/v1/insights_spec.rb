require 'rails_helper'

RSpec.describe "Api::V1::Insights", type: :request do
  describe "GET /api/v1/insights/country/:country" do
    before do
      create(:employee, country: "India", salary: 50000, currency: "INR")
      create(:employee, country: "India", salary: 60000, currency: "INR")
      create(:employee, country: "USA", salary: 70000, currency: "USD")
      create(:employee, country: "USA", salary: 80000, currency: "USD")
    end

    it "returns insights for a specific country" do
      get "/api/v1/insights/country/India"
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)

      expect(json_response["data"]["count"]).to eq(2)
      expect(json_response["data"]["average_salary"]).to eq(55000)
      expect(json_response["data"]["max_salary"]).to eq(60000)
      expect(json_response["data"]["min_salary"]).to eq(50000)
    end

    it "returns insights for another country" do
      get "/api/v1/insights/country/USA"
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)

      expect(json_response["data"]["count"]).to eq(2)
      expect(json_response["data"]["average_salary"]).to eq(75000)
      expect(json_response["data"]["max_salary"]).to eq(80000)
      expect(json_response["data"]["min_salary"]).to eq(70000)
    end

    it "returns not found for a country with no employees" do
      get "/api/v1/insights/country/UK"
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response["data"]["count"]).to eq(0)
      expect(json_response["data"]["average_salary"]).to eq(0)
      expect(json_response["data"]["max_salary"]).to eq(0)
      expect(json_response["data"]["min_salary"]).to eq(0)
    end
  end
end
