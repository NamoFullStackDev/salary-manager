class EmployeeSerializer
  def self.call(employee)
    {
      id: employee.id,
      full_name: employee.full_name,
      email: employee.email,
      job_title: employee.job_title,
      country: employee.country,
      salary: employee.salary,
      currency: employee.currency,
      employment_type: employee.employment_type,
      created_at: employee.created_at,
      updated_at: employee.updated_at
    }
  end
end
