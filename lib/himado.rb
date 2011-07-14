#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require 'rubygems'
require 'open-uri'
require 'uri'
require 'nokogiri'
require 'kconv'
require 'mechanize'

class Himado

  class Error < Exception
  end

  def initialize(user_agent=nil)
    @agent = Mechanize.new
    @agent.user_agent = user_agent
  end

  def get(url)
    @agent.get(url)
  end

  def videos(params={:sort => 'movie_id'})
    url = "http://himado.in/"
    url += '?' + params.map{|k,v|
      "#{k}=#{URI.encode v.to_s}"
    }.join('&')
    doc = Nokogiri::HTML @agent.get(url).body.toutf8
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
    doc = Nokogiri::HTML @agent.get(url).body.toutf8

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
    res[:id] = url.scan(/\/(\d+)$/).first.first
    
    return res
  end
end

if $0 == __FILE__
  himado = Himado.new
  p videos = himado.videos
  p himado.video(videos.first[:url])
  p himado.videos({:keyword => 'Steins;Gate'})
end
