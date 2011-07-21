
class Video
  include Mongoid::Document
  field :error_count, :type => Integer, :default => 0
end
