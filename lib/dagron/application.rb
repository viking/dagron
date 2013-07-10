module Dagron
  class Application < Sinatra::Base
    set :root, Root.to_s
    enable :reload_templates if development?

    get "/" do
      erb :index
    end

    get "/maps" do
      @maps = Map.all
      erb :'maps/index'
    end

    post "/maps" do
      name = params[:name]
      filename = data = nil
      if params[:data].is_a?(Hash)
        filename = params[:data][:filename]
        data = params[:data][:tempfile].read
      end
      map = Map.new({
        :name => params[:name], :filename => filename,
        :data => data
      })
      if map.valid?
        map.save
        redirect '/maps'
      end
    end
  end
end
