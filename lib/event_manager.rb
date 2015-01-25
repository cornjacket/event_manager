require 'csv'
require 'sunlight/congress'
require 'erb'

Sunlight::Congress.api_key = "63e303664fdd441b937dc66b24ae0c32"

def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5,"0")[0..4]
end	

def legislators_by_zipcode(zipcode)
  legislators = Sunlight::Congress::Legislator.by_zipcode(zipcode) 	
end

def save_thank_you_letter(id, form_letter)
  Dir.mkdir("output") unless Dir.exists?("output")
  filename = "output/thanks_#{id}.html"

  File.open(filename,'w') do |file|
    file.puts form_letter
  end
end

puts "EventManager initialized."

contents = CSV.open "event_attendees.csv", headers: true, header_converters: :symbol

template_letter = File.read "form_letter.erb"
erb_template = ERB.new template_letter

contents.each do |row|
  id = row[0]
  name = row[:first_name]
  phone = row[:homephone]

#  phone.gsub!('-','')
  phone.gsub!(/[^0-9]/,'')
  #a.gsub!(/[^0-9A-Za-z]/, '')
 
 case phone.length
 when 10
   puts phone
 when 11
   puts (phone[0] == '1') ? phone[1..10] : ""
 else
   puts ""
 end

  puts phone

  
  # removed for now, replace later
  #zipcode = clean_zipcode(row[:zipcode])

  #legislators = legislators_by_zipcode(zipcode)

  #form_letter = erb_template.result(binding)
  #save_thank_you_letter(id, form_letter)

end

=begin
lines = File.readlines "event_attendees.csv"
lines.each_with_index do |line, index|
  next if index == 0
  columns = line.split(",")
  name = columns[2]
  puts name
end
=end