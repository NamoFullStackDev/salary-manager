class Api::V1::InsightsController < ApplicationController
  def country
    render json: { data: SalaryInsightsService.country(params[:country].titleize) }, status: :ok
  end

  def job_title
    render json: { data: SalaryInsightsService.job_title(params[:job_title].titleize, params[:country].titleize) }, status: :ok
  end

  def top_job_titles
    render json: { data: SalaryInsightsService.top_job_titles(params[:country].titleize) }, status: :ok
  end
end
