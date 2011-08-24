tools
=====

Install Dependencies
--------------------

    % gem install mongoid bson bson_ext nokogiri ArgsParser

crawl
-----

    % ruby -Ku crawl.rb -help
    % ruby -Ku crawl.rb -loop -interval 600


download
--------

    % ruby -Ku download.rb -help
    % ruby -Ku download.rb -loop -interval 5


delete
------

    % ruby -Ku delete.rb

check EXIF
----------

    % brew install exiftool
    % gem install mini_exiftool
    % ruby check_exif.rb -loop -interval 5

make thumbnails
---------------

install ffmpeg, imagemagick and [video2gif](https://github.com/shokai/video2gif)

    % brew install ffmpeg imagemagick
    % git clone git@github.com:shokai/video2gif.git


make thumbnails

    % ruby make_thumbnails.rb -h
    % ruby make_thumbnails.rb -video2gif /path/to/video2gif -loop -interval 5
