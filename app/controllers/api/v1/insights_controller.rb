class Api::V1::InsightsController < ApplicationController
  def country
    country = params[:country].titleize
    employees = Employee.where(country: country)

    data = build_country_insights(employees)

    render json: { data: data }, status: :ok
  end

  private

  def build_country_insights(employees)
    {
      count: employees.count,
      average_salary: employees.average(:salary).to_i || 0,
      max_salary: employees.maximum(:salary) || 0,
      min_salary: employees.minimum(:salary) || 0
    }
  end
end
