#! /usr/bin/env ruby
##****************************************************************************
# RUBY - Scrapper
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
#
#****************************************************************************
class Scrapper
	attr_accessor :array_town

	def initialize(url)
		url_dept = url
	    html = Nokogiri::HTML(open(url_dept))
	    @array_town = []

	    html.css('.lientxt').map do |link_to_town|
	      _town = link_to_town.text
	      _email = get_townhall_email("http://annuaire-des-mairies.com#{(link_to_town['href'])[1..(link_to_town['href']).length]}")
	      @array_town << {_town => _email}
	    end
	    @array_town.flatten!
	end

	def get_townhall_email(url) #From an url retrieves the email address 
	    html = Nokogiri::HTML(open(url))
	    email_town = html.css('section:nth-child(2) div table tbody tr:nth-child(4) > td:nth-child(2)').text
	end
end
# End of Program's name
#.............................................................................
#.............................................................................
