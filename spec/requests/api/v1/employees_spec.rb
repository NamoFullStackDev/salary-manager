require 'rails_helper'

RSpec.describe "Api::V1::Employees", type: :request do
  let(:valid_params) do
    {
      employee: {
        full_name: "John Doe",
        email: "john@example.com",
        job_title: "Software Engineer",
        country: "India",
        salary: 50000,
        currency: "INR",
        employment_type: "full_time"
      }
    }
  end

  describe "POST /api/v1/employees" do
    it "creates an employee with valid parameters" do
      expect {
        post "/api/v1/employees", params: valid_params
      }.to change(Employee, :count).by(1)

      expect(response).to have_http_status(:created)
      json_response = JSON.parse(response.body)
      expect(json_response["data"]["full_name"]).to eq("John Doe")
      expect(json_response["data"]["email"]).to eq("john@example.com")
    end

    it "returns errors with invalid parameters" do
      invalid_params = {
        employee: {
          full_name: "",
          email: "invalid_email",
          job_title: "",
          country: "",
          salary: -1000,
          currency: "",
          employment_type: ""
        }
      }

      expect {
        post "/api/v1/employees", params: invalid_params
      }.not_to change(Employee, :count)

      expect(response).to have_http_status(:unprocessable_entity)
      json_response = JSON.parse(response.body)
      expect(json_response["errors"]).to include("Full name can't be blank")
      expect(json_response["errors"]).to include("Email is invalid")
      expect(json_response["errors"]).to include("Job title can't be blank")
      expect(json_response["errors"]).to include("Country can't be blank")
      expect(json_response["errors"]).to include("Salary must be greater than or equal to 0")
      expect(json_response["errors"]).to include("Currency can't be blank")
      expect(json_response["errors"]).to include("Employment type can't be blank")
    end
  end

  describe "GET /api/v1/employees" do
    before do
      create_list(:employee, 3)
    end

    it "returns a list of employees" do
      get "/api/v1/employees"
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response["data"].length).to eq(3)
    end
  end

  describe "GET /api/v1/employees/:id" do
    let(:employee) { create(:employee) }

    it "returns the employee details" do
      get "/api/v1/employees/#{employee.id}"
      expect(response).to have_http_status(:ok)

      json_response = JSON.parse(response.body)
      expect(json_response["data"]["id"]).to eq(employee.id)
      expect(json_response["data"]["full_name"]).to eq(employee.full_name)
    end

    it "returns not found for non-existent employee" do
      get "/api/v1/employees/999999"
      expect(response).to have_http_status(:not_found)
      json_response = JSON.parse(response.body)
      expect(json_response["error"]).to eq("Resource not found")
    end
  end
end
