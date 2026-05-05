class Api::V1::InsightsController < ApplicationController
  def country
    country = params[:country].titleize
    scope = Employee.where(country: country)

    data = build_country_insights(scope)

    render json: { data: data }, status: :ok
  end

  def job_title
    scope = Employee.where(country: params[:country].titleize, job_title: params[:job_title].titleize)

    render json: { data: build_country_insights(scope) }, status: :ok
  end

  private

  def build_country_insights(scope)
    {
      count: scope.count,
      average_salary: scope.average(:salary)&.to_i,
      max_salary: scope.maximum(:salary) || 0,
      min_salary: scope.minimum(:salary) || 0
    }
  end
end
