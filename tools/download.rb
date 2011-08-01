#!/usr/bin/env ruby
require File.dirname(__FILE__)+'/helper'
require 'digest/md5'
require 'FileUtils'
require 'open-uri'
require 'ArgsParser'

parser = ArgsParser.parser
parser.bind(:loop, :l, 'do loop', false)
parser.bind(:interval, :i, 'loop interval (sec)', 5)
parser.bind(:help, :h, 'show help')
first, params = parser.parse(ARGV)

if parser.has_option(:help)
  puts parser.help
  exit
end

FileUtils.mkdir_p(@@dir) unless File.exists? @@dir

loop do
  videos = Video.where(:file => nil,
                       :video_url => /^http.+/,
                       :error_count.lt => @@conf['retry']).asc(:error_count)
  
  if videos.count > 0
    puts "#{videos.count} videos in queue"
    video = videos.first
    
    puts video.title + ' - ' + video.url
    fname = Digest::MD5.hexdigest(video.video_url)
    begin
      data = open(video[:video_url]).read
    rescue => e
      STDERR.puts e
      data = nil
    rescue Timeout::Error => e
      STDERR.puts e
      data = nil
    end
    if data != nil
      open("#{@@dir}/#{fname}", 'w+'){|out|
        out.write data
      }
      video[:file] = fname
      video[:download_at] = Time.now.to_i
      video.save
      puts "=> download complete"
    else
      video.error_count += 1
      video.save
    end
  end

  break unless params[:loop]
  sleep params[:interval].to_i
end