# -*- coding: utf-8 -*-

before do
  @title = 'himado download player'
end

get '/' do
  @per_page = params['per_page'].to_i
  @per_page = @@conf['per_page'] if @per_page < 1
  @page = params['page'].to_i
  @page = 1 if @page < 1
  videos = Video.not_in(:hide => [true]).not_in(:file => [nil]).where(:file.exists => true).desc(:_id)
  @video_count = videos.count
  @videos = videos.skip(@per_page*(@page-1)).limit(@per_page)
  haml :index
end

get '/tag/:tag' do
  @tag = params[:tag].to_s
  @per_page = params['per_page'].to_i
  @per_page = @@conf['per_page'] if @per_page < 1
  @page = params['page'].to_i
  @page = 1 if @page < 1
  videos = Video.not_in(:hide => [true]).not_in(:file => [nil]).where(:file.exists => true, :tags => /^#{@tag}$/i).desc(:_id)
  @video_count = videos.count
  @videos = videos.skip(@per_page*(@page-1)).limit(@per_page)
  haml :index
end

get '/search/:word' do
  @word = params[:word]
  @per_page = params['per_page'].to_i
  @per_page = @@conf['per_page'] if @per_page < 1
  @page = params['page'].to_i
  @page = 1 if @page < 1
  videos = Video.all(:conditions => 
                     {"$or" => [{:title => /#{@word}/i},
                                {:tags => /#{@word}/i},
                                {:url => /#{@word}/i}]}).not_in(:hide => [true]).where(:file.exists => true).desc(:_id)
  @video_count = videos.count
  @videos = videos.skip(@per_page*(@page-1)).limit(@per_page)
  haml :index
end

get '/v/*.mp4' do
  @vid = params[:splat].first.to_s
  @video = Video.find(@vid) rescue @video = nil
  unless @video
    status 404
    @mes = "video file (#{@vid}) not found."
  else
    redirect "#{app_root}/#{@@conf['video_dir']}/#{@video.file}"
  end
end

get '/v/*.json' do
  @vid = params[:splat].first.to_s
  begin
    @video = Video.find(@vid)
    raise "video (#{@vid}) not found" if !@video or @video.hide
    @mes = @video.to_hash.to_json
  rescue => e
    STDERR.puts e
    @mes = {
      :error => true,
      :message => e
    }.to_json
  end
end

post '/v/*.json' do
  @vid = params[:splat].first.to_s
  @tags = params['tags'].delete_if{|tag| tag.to_s.size < 1}.uniq
  begin
    @video = Video.find(@vid)
    raise "video (#{@vid}) not found" if !@video or @video.hide
    @video.tags = @tags
    @video.save
    @mes = {
      :error => false,
      :data => @video.to_hash
    }.to_json
  rescue => e
    STDERR.puts e
    @mes = {
      :error => true,
      :message => e.to_s
    }.to_json
  end
end

delete '/v/:id' do
  @vid = params[:id].to_s
  begin
    video = Video.find(@vid)
    File.delete "#{@@dir}/#{video.file}" if File.exists? "#{@@dir}/#{video.file}"
    video.file = nil
    video.hide = true
    video.save
  rescue => e
    STDERR.puts e
    status 404
    @mes = {
      :error => true,
      :message => e.to_s
    }.to_json
  end
  @mes = {
    :error => false,
    :message => "video #{@vid} deleted"
  }.to_json
end

get '/v/:id' do
  @vid = params[:id].to_s
  @video = Video.find(@vid) rescue @video = nil
  if !@video or @video.hide
    status 404
    @mes = "video (#{@vid}) not found."
  else
    haml :video
  end
end
