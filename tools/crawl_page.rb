#!/usr/bin/env ruby
require 'rubygems'
require File.dirname(__FILE__)+'/helper'
require 'open-uri'
require 'nokogiri'
require 'uri'
require 'kconv'

parser = ArgsParser.parser
parser.bind(:loop, :l, 'do loop', false)
parser.comment(:url, 'URL of page')
parser.comment(:filter, 'download file pattern', '.+\.(mp4|mov|flv)$')
parser.comment(:basic_user, 'basic auth user')
parser.comment(:basic_pass, 'basic auth passwd')
parser.bind(:interval, :i, 'loop interval (sec)', 600)
parser.bind(:help, :h, 'show help')
first, params = parser.parse(ARGV)

if parser.has_option(:help) or !parser.has_param(:url)
  puts parser.help
  exit
end

loop do
  if parser.has_params([:basic_user, :basic_pass])
    http_opt = {
      :http_basic_authentication => [params[:basic_user], params[:basic_pass]]
    }
  end
  
  doc = Nokogiri::HTML open(params[:url], http_opt).read.toutf8
  urls = doc.xpath('//a').to_a.map{|i|
    if URI.parse(i['href']).class == URI::Generic
      res = params[:url].gsub(/\/$/, '') + '/' + i['href']
    else
      res = i['href']
    end
    res
  }.delete_if{|i|
    !(i =~ Regexp.new(params[:filter]))
  }
  
  urls.each{|u|
    v = {
      :title => URI.decode(u.split(/\//).last),
      :video_url => u,
      :crawl_at => Time.now.to_i,
      :url => params[:url],
      :http_opt => http_opt
    }
    puts v[:title] + ' - ' + v[:url]
    next if Video.where(:video_url => u).count > 0
    puts ' => saved!' if Video.new(v).save
  }

  break unless params[:loop]
  sleep params[:interval].to_i
end
