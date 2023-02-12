#! /usr/bin/env ruby

require 'uri'
require 'net/http'
require 'json'

# Get public IP address
puts "Locating your IP address"
uri = URI('https://api.ipify.org/?format=json')
resp = Net::HTTP.get(uri)
ip_addr_resp = JSON.parse(resp)
puts "Public IP Address on Executing Machine: #{ip_addr_resp['ip']}"

# Get geo location of this IP
puts "Finding your executing machine location"
uri = URI('https://geocode.xyz/') 	 
resp = Net::HTTP.post_form(uri, 'locate' => ip_addr_resp['ip'], 'geoit' => 'json')
geo_resp = JSON.parse(resp.body)
puts "Latitude: #{geo_resp['latt']}, Longitude: #{geo_resp['longt']}"  if resp.is_a?(Net::HTTPSuccess)

# Get weather at this geo location
puts "Retrieving 7 day forcast and temperatures"
lat = '%.2f' % geo_resp['latt']
lon = '%.2f' % geo_resp['longt']
uri_string = "https://api.open-meteo.com/v1/forecast?latitude=#{lat}&longitude=#{lon}&daily=temperature_2m_max,temperature_2m_min&timezone=America%2FNew_York"
uri = URI(uri_string)
resp = Net::HTTP.get(uri)
wx_resp = JSON.parse(resp)
puts "Low Temps(Celsius): #{wx_resp['daily']['temperature_2m_min']}, High Temps(Celsius): #{wx_resp['daily']['temperature_2m_max']}"
