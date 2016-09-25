$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'html_stripper'
require 'rack'
require 'sinatra/base'

# Rack application for HtmlStripper test
class TestApp < Sinatra::Base
  get '/echo_text' do
    content_type :text
    params[:content]
  end

  get '/echo' do
    content_type :html
    params[:content]
  end
end
