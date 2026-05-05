class Api::V1::EmployeesController < ApplicationController
  def index
    employees = Employee.all

    render json: { data: employees.map { |employee| EmployeeSerializer.call(employee) } }, status: :ok
  end

  def create
    employee = Employee.new(employee_params)

    if employee.save
      render json: { data: EmployeeSerializer.call(employee) }, status: :created
    else
      render json: { errors: employee.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    employee = Employee.find(params[:id])
    render json: { data: EmployeeSerializer.call(employee) }, status: :ok
  end

  private

  def employee_params
    params.require(:employee).permit(
      :full_name,
      :email,
      :job_title,
      :country,
      :salary,
      :currency,
      :employment_type
    )
  end
end
