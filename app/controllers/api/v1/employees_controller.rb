class Api::V1::EmployeesController < ApplicationController
  def index
    employees = Employee.all

    employees = employees.where(country: params[:country].titleize) if params[:country].present?
    employees = employees.where(job_title: params[:job_title].titleize) if params[:job_title].present?

    employees = employees.page(params[:page]).per(params[:per_page] || 20)

    render json: {
      data: EmployeeSerializer.call(employees),
      meta: {
        current_page: employees.current_page,
        per_page: employees.limit_value,
        total_pages: employees.total_pages
      }
    }, status: :ok
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
    render_success(EmployeeSerializer.call(employee))
  end

  def update
    employee = Employee.find(params[:id])

    if employee.update(employee_params)
      render_success(EmployeeSerializer.call(employee))
    else
      render json: { errors: employee.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    employee = Employee.find(params[:id])
    employee.destroy
    head :no_content
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

  def render_success(data)
    render json: { data: data }, status: :ok
  end
end
