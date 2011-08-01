#!/usr/bin/env ruby
# -*- coding: undecided -*-
# DBに登録されていないファイルを削除する
require File.dirname(__FILE__)+'/helper'
require 'FileUtils'

Dir.glob("#{@@dir}/*").each{|f|
  fname = f.split(/\//).last
  begin
  if Video.where(:file => fname).count < 1
    puts "delete #{fname}"
    File.delete f
  end
  rescue => e
    STDERR.puts e
  end
}
