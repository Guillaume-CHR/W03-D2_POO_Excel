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
  url = "http://annuaire-des-mairies.com/val-d-oise.html"
  scrapper = Scrapper.new(url)
  array_to_record = scrapper.array_town
end 

def record(file) #For each sub-hash, the value is join with commas
  main.each do |_hash|
  	file.puts(_hash.map {|x,y| "#{x},#{y}"}.join(''))
  end
end

def save_as_JSON #Call method 'record' with file 'email.JSON'
  record(File.open("db/email.JSON","w"))

  #Alternative where text is in one row
  # File.open("db/email.json","w") do |f|
  #   f.write(main.to_json)
  # end
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

def save_as_CSV #Call method 'record' with file 'email.csv'
  record(File.open("db/email.csv","w"))

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
    puts "_nYou've selected format JSON - Great choice for unknown use"
    puts "(... loading...)"
    save_as_JSON
    system("cd db/email.JSON")
    puts "(All set)"
  elsif choice == 2
    puts "You've selected format Google Drive - Great choice to save the planet in Cloud"
    puts "(... loading...)"
    save_as_spreedsheet
    puts "Access the hereafter link for checks: https://docs.google.com/spreadsheets/d/1Gc83X5sHlXEhKl4EZar1qdVqsJCpLC14ZrnQZAh9JO0/edit?usp=sharing"
    puts "(All set)"
  elsif choice == 3
    puts "You've selected format CSV - Great choice, all you need is to convert it in Excel"
    puts "(... loading...)"
    save_as_CSV
    system("cd db/email.csv")
    puts "(All set)"
  end
end

perform
# End of Program's name
#.............................................................................
#.............................................................................