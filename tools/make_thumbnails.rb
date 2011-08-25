#!/usr/bin/env ruby
require 'rubygems'
require File.dirname(__FILE__)+'/helper'

parser = ArgsParser.parser
parser.bind(:loop, :l, 'do loop', false)
parser.bind(:interval, :i, 'loop interval (sec)', 5)
parser.comment(:video2gif, 'video2gif command path')
parser.comment(:gif_fps, 'gif fps', 1)
parser.comment(:video_fps, 'video fps', 0.01)
parser.comment(:size, 'size', '160x90')
parser.bind(:help, :h, 'show help')
first, params = parser.parse(ARGV)

if parser.has_option(:help) or !parser.has_params([:video2gif])
  puts parser.help
  exit
end

loop do
  videos = Video.not_in(:file => [nil]).where(:exif.exists => true, :thumb_gif.exists => false)
  loop do
    break if videos.empty?
    v = videos.shift
    puts "#{v.title}(id:#{v.id}) - #{videos.count+1} videos in thumbnail queue"
    file = "#{@@dir}/#{v.file}"
    next unless File.exists? file
    out = "#{@@thumb_dir}/#{v.file}.gif"
    puts cmd = "#{params[:video2gif]} -i #{file} -o #{out} -video_fps #{params[:video_fps]} -gif_fps #{params[:gif_fps]} -size #{params[:size]}"
    system cmd
    next unless File.exists? out
    v[:thumb_gif] = "#{v.file}.gif"
    v.save
  end
  break unless params[:loop]
  sleep params[:interval].to_i
end


