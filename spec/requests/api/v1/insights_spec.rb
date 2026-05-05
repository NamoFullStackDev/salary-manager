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
      expect(json_response["data"]["average_salary"]).to be_nil
      expect(json_response["data"]["max_salary"]).to eq(0)
      expect(json_response["data"]["min_salary"]).to eq(0)
    end
  end

  describe "GET /api/v1/insights/job_title" do
    before do
      create(:employee, job_title: "Software Engineer", salary: 50000, country: "India")
      create(:employee, job_title: "Software Engineer", salary: 60000, country: "India")
      create(:employee, job_title: "Product Manager", salary: 70000, country: "USA")
      create(:employee, job_title: "Product Manager", salary: 80000, country: "USA")
    end

    it "returns average salary for a specific job title in a specific country" do
      get "/api/v1/insights/job_title", params: { job_title: "Software Engineer", country: "India" }
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)

      expect(json_response["data"]["average_salary"]).to eq(55000)
    end

    it "returns nil for a job title with no employees in the specified country" do
      get "/api/v1/insights/job_title", params: { job_title: "Data Scientist", country: "USA" }
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)

      expect(json_response["data"]["average_salary"]).to be_nil
    end
  end

  describe "GET /api/v1/insights/top_job_titles" do
    before do
      create(:employee, job_title: "Software Engineer", salary: 50000, country: "India")
      create(:employee, job_title: "Software Engineer", salary: 60000, country: "India")
      create(:employee, job_title: "Product Manager", salary: 70000, country: "USA")
      create(:employee, job_title: "Product Manager", salary: 80000, country: "USA")
      create(:employee, job_title: "Data Scientist", salary: 90000, country: "USA")
    end

    it "returns top job titles by average salary in a specific country" do
      get "/api/v1/insights/top_job_titles", params: { country: "USA" }
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)

      expect(json_response["data"][0]["job_title"]).to eq("Data Scientist")
      expect(json_response["data"][0]["average_salary"]).to eq(90000)
      expect(json_response["data"][1]["job_title"]).to eq("Product Manager")
      expect(json_response["data"][1]["average_salary"]).to eq(75000)
    end

    it "returns an empty array if there are no employees in the specified country" do
      get "/api/v1/insights/top_job_titles", params: { country: "UK" }
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)

      expect(json_response["data"]).to be_empty
    end
  end
end
