# -*- coding: utf-8 -*-

before do
  @title = 'himado download player'
end

get '/' do
  @videos = Video.where(:file => /.+/).desc(:_id)
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

delete '/v/:id' do
  @vid = params[:id].to_s
  begin
    video = Video.find(@vid)
    File.delete "#{@@dir}/#{video.file}"
    video.file = nil
    video[:delete] = true
    video.save
  rescue => e
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
