class InfoController < ApplicationController
  def index
    json_file = File.read( Rails.root.join('info.json'))
    json = JSON.parse(json_file)
    render json: { version: json['version'] }
  end
end
