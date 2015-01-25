require 'csv'
require 'sunlight/congress'

Sunlight::Congress.api_key = "63e303664fdd441b937dc66b24ae0c32"

# keep track of the number of occurences for each hour 0-23
$hour_histogram = Hash.new(0)

# keep trackk of the number of occurences for each day
$day_histogram = Hash.new(0)

def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5,"0")[0..4]
end	

def legislators_by_zipcode(zipcode)
  legislators = Sunlight::Congress::Legislator.by_zipcode(zipcode) 	
end

def clean_phone_number(phone)
  phone.gsub!(/[^0-9]/,'') 
  clean = case phone.length
  when 10
    phone
  when 11
    (phone[0] == '1') ? phone[1..10] : "0000000000"
  else
    "0000000000"
  end
  clean[0..2] + '-' + clean[3..5] + '-' + clean[6..9]
end	

def hour_of_the_day(date)
  DateTime.strptime(date, '%m/%d/%Y %H:%M').hour
end

def count_hour(hour)
  $hour_histogram[hour] += 1
end

def day_of_the_week(date)
  DateTime.strptime(date, '%m/%d/%Y %H:%M').wday
end

def count_day(day)
  $day_histogram[day] += 1
end

puts "EventManager initialized."

contents = CSV.open "event_attendees.csv", headers: true, header_converters: :symbol

contents.each do |row|
  id = row[0]
  name = row[:first_name]
  phone = row[:homephone]
  reg_date = row[:regdate]

  count_hour(hour_of_the_day(reg_date))
  count_day(day_of_the_week(reg_date))
end

# Display hour histogram
puts "\nHour/Count Histogram"
$hour_histogram.sort.each { |hour, count| puts "#{hour} o'clock = #{count}"}

puts "\nDay/Count Histogram"
$day_histogram.sort.each { |day, count| puts "#{Date::DAYNAMES[day]} = #{count}"}