class SalaryInsightsService
  def self.country(country)
    scope = Employee.where(country: country)
    {
      count: scope.count,
      average_salary: scope.average(:salary)&.to_i,
      max_salary: scope.maximum(:salary) || 0,
      min_salary: scope.minimum(:salary) || 0
    }
  end

  def self.job_title(job_title, country)
    scope = Employee.where(country: country, job_title: job_title)
    {
      average_salary: scope.average(:salary)&.to_i
    }
  end

  def self.top_job_titles(country)
    results = Employee.where(country: country).group(:job_title).select("job_title, AVG(salary) as average_salary").order("average_salary DESC")

    results.map do |record|
      {
        job_title: record.job_title,
        average_salary: record.average_salary.to_i
      }
    end
  end
end
