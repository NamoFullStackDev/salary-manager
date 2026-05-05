class Employee < ApplicationRecord
  enum :employment_type, { full_time: 0, contract: 1, intern: 2 }

  validates :full_name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :job_title, presence: true
  validates :country, presence: true
  validates :salary, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :currency, presence: true
  validates :employment_type, presence: true

  before_validation :normalize_fields

  private

  def normalize_fields
    self.full_name = full_name.strip.titleize if full_name.present?
    self.email = email.strip.downcase if email.present?
    self.job_title = job_title.strip.titleize if job_title.present?
    self.country = country.strip.titleize if country.present?
    self.currency = currency.strip.upcase if currency.present?
  end
end
