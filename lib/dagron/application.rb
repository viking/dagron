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
      map = Map.new(:name => params[:name])
      if map.valid?
        map.save
        redirect '/maps'
      end
    end

    get "/maps/:id" do
      @map = Map[:id => params[:id]]
      @images = @map.images
      erb :'maps/show'
    end

    post "/maps/:id" do
      map = Map[:id => params[:id]]
      map.set_only(params[:map], :viewport_x, :viewport_y, :viewport_w, :viewport_h)
      if map.valid?
        map.save
        if request.xhr?
          content_type 'application/json'
          {'map' => map}.to_json
        else
          redirect "/maps/#{map.id}"
        end
      end
    end

    post "/maps/:id/images" do
      map = Map[:id => params[:id]]

      name = params[:name]
      filename = data = nil
      if params[:data].is_a?(Hash)
        filename = params[:data][:filename]
        data = params[:data][:tempfile].read
      end
      image = Image.new({
        :name => params[:name], :filename => filename,
        :data => data, :map_id => map.id
      })
      if image.valid?
        image.save
        redirect "/maps/#{map.id}"
      end
    end

    get "/maps/:map_id/images/:id" do
      map = Map[:id => params[:map_id]]
      image = map.images_dataset[:id => params[:id]]
      content_type image.mime_type
      image.data
    end

    post "/maps/:map_id/images/:id" do
      map = Map[:id => params[:map_id]]
      image = map.images_dataset[:id => params[:id]]
      image.set_only(params[:image], :visible)
      if image.valid?
        image.save
        if request.xhr?
          content_type 'application/json'
          "{\"image\":#{image.to_json(:except => [:data])}}"
        else
          redirect "/maps/#{map.id}"
        end
      end
    end
  end
end
