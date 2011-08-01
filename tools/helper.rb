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
end

@@dir = File.dirname(__FILE__)+'/../'+@@conf['dir']

Mongoid.configure{|conf|
  conf.master = Mongo::Connection.new(@@conf['mongo_server'], @@conf['mongo_port']).db(@@conf['mongo_dbname'])
}
