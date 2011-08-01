#!/usr/bin/env ruby
require 'rubygems'
require File.dirname(__FILE__)+'/helper'

himado = Himado.new

@@conf['tags'].each{|tag|
  puts "tag : #{tag}"
  begin
    videos = himado.videos(:keyword => tag)
  rescue => e
    STDERR.puts e
    next
  rescue Timeout::Error => e
    STDERR.puts e
    next
  end
  videos.each{|v|
    begin
      video = himado.video(v[:url])
    rescue => e
      STDERR.puts e
      next
    rescue Timeout::Error => e
      STDERR.puts e
      next
    end
    puts video[:title] + ' - ' + video[:url]
    next if video[:video_url].to_s.size < 1 or !(video[:video_url].to_s =~ /^http.+/)
    video[:crawl_at] = Time.now.to_i
    unless Video.where(:video_url => video[:video_url]).count > 0
      puts ' => saved!' if Video.new(video).save
    end
    sleep 5
  }
}
