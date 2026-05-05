class Api::V1::InsightsController < ApplicationController
  def country
    country = params[:country].titleize
    employees = Employee.where(country: country)

    count = employees.count
    average_salary = employees.average(:salary) || 0
    max_salary = employees.maximum(:salary) || 0
    min_salary = employees.minimum(:salary) || 0

    render json: {
      data: {
        count: count,
        average_salary: average_salary.to_f,
        max_salary: max_salary.to_f,
        min_salary: min_salary.to_f
      }
    }, status: :ok
  end
end
