#!/usr/bin/env ruby
require 'rubygems'
require 'mini_exiftool'
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
  videos = Video.not_in(:hide => [true]).not_in(:file => [nil]).where(:file.exists => true, :exif => nil)
  videos.each{|v|
    puts file = "#{@@dir}/#{v.file}"
    begin
      exif = MiniExiftool.new file
      raise "#{exif['mime_type']} is not video file" unless exif['mime_type'] =~ /^video\/.+/i
    rescue => e
      STDERR.puts e
      File.delete file if File.exists? file
      v.hide = true
      v.file = nil
      v.save
      next
    end
    ext = exif['FileType'].downcase
    v.file += ".#{ext}" unless v.file =~ /.+\.#{ext}$/i
    File.rename(file, "#{@@dir}/#{v.file}") rescue next
    puts " => #{v.file}"
    v.exif = exif.to_hash
    p v.exif
    v.save
  }
  break unless params[:loop]
  sleep params[:interval].to_i
end


