#!/usr/bin/env ruby
require File.dirname(__FILE__)+'/helper'
require 'digest/md5'
require 'FileUtils'
require 'open-uri'

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
  videos = Video.not_in(:hide => [true]).where(:file => nil,
                                               :video_url => /^http.+/,
                                               :error_count.lt => @@conf['retry']).asc(:error_count)
  interval = params[:interval].to_i
  if videos.count > 0
    puts "#{videos.count} videos in queue"
    video = videos.first
    file_exists = Video.not_in(:hide => [true]).where(:file.ne => nil, :url => video.url).count > 0
    puts video.title + ' - ' + video.url
    fname = Digest::MD5.hexdigest(video.video_url)
    http_opt = Hash.new
    if video[:http_opt] != nil
      video.http_opt.keys.each{|k|
        http_opt[k.to_sym] = video.http_opt[k]
      }
    end
    begin
      data = file_exists ? nil : open(video[:video_url], http_opt).read
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
      interval = 3
    end
  end

  break unless params[:loop]
  sleep interval
end
