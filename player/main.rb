# -*- coding: utf-8 -*-

before do
  @title = 'himado download player'
end

get '/' do
  @videos = Video.where(:file => /.+/)
  haml :index
end

get '/v/*.mp4' do
  @vid = params[:splat].first.to_s
  @video = Video.find(@vid) rescue @video = nil
  unless @video
    status 404
    @mes = "video file (#{@vid}) not found."
  else
    redirect "#{app_root}/videos/#{@video.file}"
  end
end

get '/v/:id' do
  @vid = params[:id].to_s
  @video = Video.find(@vid) rescue @video = nil
  unless @video
    status 404
    @mes = "video (#{@vid}) not found."
  else
    haml :video
  end
end
