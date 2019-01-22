#! /usr/bin/env ruby
##****************************************************************************
# RUBY - @NameOfTheProgram
#****************************************************************************
#   Ruby's Program - Name of the program
#   Written by: Guillaume CHRISTE
# 	Date: Date of modification
#   
#   Description:
# 		- 
# 		- 
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
def main
  url = "http://annuaire-des-mairies.com/val-d-oise.html"
  scrapper = Scrapper.new(url)
  array_to_record = scrapper.array_town
end

def record(file)
  main.each do |_hash|
  	file.puts(_hash.map {|x,y| "#{x},#{y}"}.join(''))
  end
end

def save_as_JSON
  record(File.open("db/email.JSON","w"))
end

def save_as_spreedsheet
  
end

def save_as_CSV
  record(File.open("db/email.csv","w"))
end

def perform
  #Implement user selection
  save_as_JSON

  save_as_CSV
end

perform

##### Google Drive

##### CSV

# End of Program's name
#.............................................................................
#.............................................................................