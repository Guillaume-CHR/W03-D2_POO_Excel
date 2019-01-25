#! /usr/bin/env ruby
##****************************************************************************
# RUBY - Main Application 
#****************************************************************************
#   Ruby's Program - app
#   Written by: Guillaume CHRISTE
# 	Date: Date of modification
#   
#   Description:
# 		- Calls the method 'scrapper' to retrieve an array of city/emails
# 		- Convert this array into either JSON, Google Sheet or CSV
# 		
# 	Gems:
  		require 'bundler'
  		Bundler.require

#	Links:
		$:.unshift File.expand_path("./../lib", __FILE__)
		require 'app/scrapper'
		# require 'views/'
#
#****************************************************************************
def main # Create an instance of class 'Scrapper' with attribute array_town
puts page_mairie = Scrapper.new("http://annuaire-des-mairies.com/haute-garonne.html")
puts page_mairie1 = Scrapper.new("http://annuaire-des-mairies.com/haute-garonne-2.html")
puts page_mairie2 = Scrapper.new("http://annuaire-des-mairies.com/haute-garonne-3.html")

end 

def save_as_JSON #Record email using format to_json (~ to_i)
  File.open("db/email.json","w") do |f|
    f.write(main.to_json)
  end
end

def save_as_spreedsheet #Use Google Drive API to save in Google Drive
  session = GoogleDrive::Session.from_config("config.json")
  ws = session.spreadsheet_by_key("1Gc83X5sHlXEhKl4EZar1qdVqsJCpLC14ZrnQZAh9JO0").worksheets[0]

  i = 1
  #On each sub-hash, the key(x) and value(y) are recorded in a dedicated Google Drive cell
  main.each do |_hash|
    _hash.each do |x,y|
      ws[i,1] = x
      ws[i,2] = y
      i+=1
    end
  end
  ws.save
  ws.reload

  #Alternative
  # session = GoogleDrive::Session.from_config("config.json")
  # ws = session.spreadsheet_by_key("1Gc83X5sHlXEhKl4EZar1qdVqsJCpLC14ZrnQZAh9JO0").worksheets[0]
  # puts ws.insert_rows(1, main)
  # ws save
end

def save_as_CSV #Record in format CSV
  file = File.open("db/email.csv","w")
  main.each do |_hash|
    file.puts(_hash.map {|x,y| "#{x},#{y}"}.join(''))
  end

  # Alternative
  # CSV.open("db/email.csv", "w") {|csv| main.to_a.each {|_array| csv << _array}}
end

def perform #User menu
  system("clear")
  puts "***************************************************************************"
  puts " Hey, user!! Please select a format to extract your list of array"
  puts "***************************************************************************"
  puts ""
  puts " Enter 1 for JSON"
  puts " Enter 2 for Google Sheets"
  puts " Enter 3 for CSV"
  puts ""
  puts "***************************************************************************"
  print "Enter your choice here > "
  choice = gets.chomp.to_i

  if choice != choice.to_i or choice > 3 or choice <=0
    puts "ERROR - Let's start over in 1 sec"
    sleep(1)
    perform
  elsif choice == 1
    puts "\nYou've selected format JSON - Great choice for unknown use"
    print "(... loading...)"
    save_as_JSON
    puts "\nAll set"
  elsif choice == 2
    puts "\nYou've selected format Google Drive - Great choice to save the planet in Cloud"
    print "(... loading...)"
    save_as_spreedsheet
    puts "\nAccess the hereafter link for checks: https://docs.google.com/spreadsheets/d/1Gc83X5sHlXEhKl4EZar1qdVqsJCpLC14ZrnQZAh9JO0/edit?usp=sharing"
    puts "\nAll set"
  elsif choice == 3
    puts "\nYou've selected format CSV - Great choice, all you need is to convert it in Excel"
    print "(... loading...)"
    save_as_CSV
    puts "\nAll set"
  end
end

main
# End of Program's name
#.............................................................................
#.............................................................................