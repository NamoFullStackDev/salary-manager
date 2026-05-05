require 'rails_helper'

RSpec.describe Employee, type: :model do
  subject do
    described_class.new(
      full_name: "John Doe",
      email: "john.doe@example.com",
      job_title: "Software Engineer",
      country: "India",
      salary: 50000,
      currency: "INR",
      employment_type: "full_time"
    )
  end

  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end

  it "is not valid without an email" do
    subject.email = nil
    expect(subject).not_to be_valid
  end

  it "is not valid without a full_name" do
    subject.full_name = nil
    expect(subject).not_to be_valid
  end

  it "is not valid without a job_title" do
    subject.job_title = nil
    expect(subject).not_to be_valid
  end

  it "is not valid without a country" do
    subject.country = nil
    expect(subject).not_to be_valid
  end

  it "is not valid without a salary" do
    subject.salary = nil
    expect(subject).not_to be_valid
  end

  it "is not valid with a negative salary" do
    subject.salary = -1000
    expect(subject).not_to be_valid
  end

  it "is not valid without a currency" do
    subject.currency = nil
    expect(subject).not_to be_valid
  end

  it "is not valid without an employment_type" do
    subject.employment_type = nil
    expect(subject).not_to be_valid
  end
end
