
class Video
  include Mongoid::Document
  field :error_count, :type => Integer, :default => 0
  field :title, :type => String
  field :file, :type => String
  field :tags, :type => Array
  field :url, :type => String
  field :video_url, :type => String
  field :thumb_gif, :type => String
  field :exif, :type => Hash
  field :hide, :type => Boolean, :default => false
end
