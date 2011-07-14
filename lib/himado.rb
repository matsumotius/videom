#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require 'rubygems'
require 'open-uri'
require 'uri'
require 'nokogiri'
require 'kconv'

class Himado

  class Error < Exception
  end

  def initialize(user_agent=nil)
  end

  def videos(params={:sort => 'movie_id'})
    url = "http://himado.in/"
    url += '?' + params.map{|k,v|
      "#{k}=#{URI.encode v.to_s}"
    }.join('&')
    doc = Nokogiri::HTML open(url).read.toutf8
    doc.xpath('//a').to_a.delete_if{|a|
      !(a['href'] =~ /^http:\/\/himado\.in\/\d+$/) or !a['title']
    }.map{|a|
      {
        :url => a['href'],
        :title => a['title']
      }
    }.uniq
  end

  def video(url)
    res = Hash.new
    doc = Nokogiri::HTML open(url).read.toutf8

    res[:video_url] = doc.xpath('//script').to_a.map{|i|
      i.text
    }.join('').split(';').delete_if{|i|
      !(i =~ /var +display_movie_url += +/)
    }.map{|i|
      begin
        u = URI.decode i.scan(/'(http.+)'/).first.first
      rescue
        u = nil
      end
      u
    }.delete_if{|i| i == nil}.first
    res[:title] = doc.xpath('//h1[@id="movie_title"]').first.text
    res[:url] = url
    res[:page_id] = url.scan(/\/(\d+)$/).first.first.to_i
    res[:tags] = doc.xpath('//a').map{|a|
      begin
        tag = URI.decode a['href'].scan(/\?keyword=(.+)$/).first.first
      rescue
        tag = nil
      end
      tag
    }.delete_if{|tag| tag == nil }
    return res
  end
end

if $0 == __FILE__
  himado = Himado.new
  # p videos = himado.videos({:keyword => 'Steins;Gate'})
  p videos = himado.videos
  p himado.video(videos.first[:url])
end
