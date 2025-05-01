class Token < ApplicationRecord
  belongs_to :user

  COUNTERS = ["Green Card", "Driving Licence", "New Registration", "T/R", "Enforcement"]
  
  STATUSES = ["Pending", "In Progress", "Complete"]

  before_create :assign_token_number

  private

  def assign_token_number
    today_count = Token.where(counter: counter, created_at: Time.zone.today.all_day).count + 1
    prefix = case counter
             when "Green Card" then "GC"
             when "Driving Licence" then "DL"
             when "New Registration" then "NR"
             when "T/R" then "TR"
             when "Enforcement" then "EN"
             else "XX"
             end
    self.token_number = "#{prefix}-#{today_count.to_s.rjust(3, '0')}"
  end
 
end
