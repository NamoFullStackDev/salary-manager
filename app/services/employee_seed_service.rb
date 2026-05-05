class EmployeeSeedService
  def self.call(count: 10_000)
    first_names_path = Rails.root.join("db/first_names.txt")
    last_names_path  = Rails.root.join("db/last_names.txt")

    first_names = if File.exist?(first_names_path)
                File.readlines(first_names_path).map(&:strip)
    else
                %w[John Jane Amit Rahul Priya]
    end

    last_names = if File.exist?(last_names_path)
                  File.readlines(last_names_path).map(&:strip)
    else
                  %w[Sharma Smith Patel]
    end
    employees = []

    count.times do
      employees << {
        full_name: "#{first_names.sample} #{last_names.sample}",
        email: Faker::Internet.unique.email,
        job_title: [ "Engineer", "Manager", "Designer" ].sample,
        country: [ "India", "USA", "Canada" ].sample,
        salary: rand(30_000..150_000),
        currency: "INR",
        employment_type: 0,
        created_at: Time.current,
        updated_at: Time.current
      }
    end

    Employee.insert_all(employees)
  end
end
