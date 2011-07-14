#!/usr/bin/env ruby
require File.dirname(__FILE__)+'/helper'
require 'digest/md5'
require 'FileUtils'
require 'open-uri'

FileUtils.mkdir_p(@@conf['dir']) unless File.exists? @@conf['dir']

videos = Video.where(:file => nil,
                     :video_url => /^http.+/,
                     :error_count.lt => @@conf['retry'])

videos.each{|video|
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
    open(@@conf['dir']+'/'+fname,'w+'){|out|
      out.write data
    }
    video[:file] = fname
    video.save
    puts "=> download complete"
  else
    video[:error_count] = (video[:error_count] || 0) + 1
    video.save
  end
}

