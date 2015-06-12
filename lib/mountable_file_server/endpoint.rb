require 'sinatra'

module MountableFileServer
  class Endpoint < Sinatra::Base
    attr_reader :configuration

    def initialize(configuration)
      @configuration = configuration
      super
    end

    post '/' do
      upload = MountableFileServer::Upload.new file: params[:file], type: params[:type]
      storage = MountableFileServer::Storage.new configuration
      storage.store_temporary upload: upload
    end

    get '/*' do
      deliver_file unescape(request.path_info)
    end

    def deliver_file(filename)
      path_to_file = File.join(configuration.stored_at, 'public', filename)

      if File.file?(path_to_file)
        send_file path_to_file
      else
        pass
      end
    end
  end
end