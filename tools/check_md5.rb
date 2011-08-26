#!/usr/bin/env ruby
require 'rubygems'
require 'digest/md5'
require File.dirname(__FILE__)+'/helper'

parser = ArgsParser.parser
parser.bind(:loop, :l, 'do loop', false)
parser.bind(:interval, :i, 'loop interval (sec)', 5)
parser.bind(:help, :h, 'show help')
first, params = parser.parse(ARGV)

if parser.has_option(:help)
  puts parser.help
  exit
end

loop do
  videos = Video.where(:file => /.+/, :md5 => nil).desc(:_id)
  puts "#{videos.count} files in queue"
  videos.each do |v|
    file = "#{@@dir}/#{v.file}"
    puts "#{v.title} - #{file}"
    begin
      md5 = Digest::MD5.hexdigest(open(file).read)
      puts " => #{md5}"
      v.md5 = md5
      if Video.where(:md5 => md5).count > 0
        puts "#{md5} is already stored"
        File.delete file if File.exists? file
        v.hide = true
        v.file = nil
        puts 'deleted!!'
      end
      v.save
    rescue => e
      STDERR.puts e
    next
    end
  end
  break unless params[:loop]
  sleep params[:interval].to_i
end


