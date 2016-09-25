require 'spec_helper'
require 'html_stripper/rack'
require 'rack/test'
require 'cgi'

describe HtmlStripper::Rack do
  include Rack::Test::Methods

  let(:test_app) { TestApp.new }
  let(:app) { HtmlStripper::Rack.new(test_app) }

  context 'for text' do
    it 'keeps original content' do
      string = '<foo><!--  --><bar>   </bar></foo>'
      get "/echo_text?content=#{CGI.escape(string)}"

      expect(last_response.body).to eq string
    end
  end

  context 'for HTML' do
    it 'strips properly' do
      string = '<foo><!--  --><bar>   </bar></foo>'
      expected = '<foo><bar> </bar></foo>'
      get "/echo?content=#{CGI.escape(string)}"

      expect(last_response.body).to eq expected
    end
  end
end
