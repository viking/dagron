module Dagron
  class Application < Sinatra::Base
    set :root, Root.to_s
    enable :reload_templates if development?

    get "/" do
      redirect "/maps"
    end

    get "/maps" do
      @maps = Map.all
      erb :'maps/index'
    end

    post "/maps" do
      map = Map.new
      map.set_only(params[:map], :name)
      if map.valid?
        map.save
        redirect "/maps/#{map.id}"
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

    post "/maps/:id/delete" do
      map = Map[:id => params[:id]]
      map.destroy
      redirect "/maps"
    end

    post "/maps/:id/images" do
      map = Map[:id => params[:id]]

      attribs = params[:image]
      filename = data = nil
      if attribs[:data].is_a?(Hash)
        filename = attribs[:data][:filename]
        data = attribs[:data][:tempfile].read
      end
      image = Image.new({
        :name => attribs[:name], :filename => filename,
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
      image.set_only(params[:image], :visible, :layer)
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

    post "/maps/:map_id/images/:id/delete" do
      map = Map[:id => params[:map_id]]
      image = map.images_dataset[:id => params[:id]]
      image.destroy
      redirect "/maps/#{map.id}"
    end

    get "/maps/:id/manage" do
      @map = Map[:id => params[:id]]
      @images = @map.images_dataset.order(:layer)
      erb :'maps/manage'
    end

    get "/maps/:id/presentation" do
      @map = Map[:id => params[:id]]
      if request.xhr?
        content_type 'application/json'
        "{\"map\":#{@map.to_json},\"images\":#{@map.images_dataset.to_json(:except => [:data])}}"
      else
        @images = @map.images
        erb :'maps/presentation', :layout => false
      end
    end
  end
end
