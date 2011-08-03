require 'rubygems'
require 'mongoid'
require 'yaml'
require 'ArgsParser'
require File.dirname(__FILE__)+'/../lib/himado'
require File.dirname(__FILE__)+'/../models/video'

begin
  @@conf = YAML::load open(File.dirname(__FILE__)+'/../config.yaml').read
rescue => e
  STDERR.puts 'config.yaml load error!'
  STDERR.puts e
  exit 1
end

begin
  @@dir = File.dirname(__FILE__)+'/../'+@@conf['video_dir']
  FileUtils.mkdir_p(@@dir) unless File.exists? @@dir
  @@thumb_dir = File.dirname(__FILE__)+'/../'+@@conf['thumb_dir']
  FileUtils.mkdir_p(@@thumb_dir) unless File.exists? @@thumb_dir
rescue => e
  STDERR.puts e
  exit 1
end

Mongoid.configure{|conf|
  conf.master = Mongo::Connection.new(@@conf['mongo_server'], @@conf['mongo_port']).db(@@conf['mongo_dbname'])
}
