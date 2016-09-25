require 'html_stripper'

class HtmlStripper
  # Rack middleware of HtmlStripper
  class Rack
    def initialize(app, opts = {})
      @app = app
      @stripper = HtmlStripper.new opts
    end

    def call(env)
      res = @app.call(env)
      type = res[1]['Content-Type']
      return res if !type || type !~ %r{^text/html}
      # change body
      text = @stripper.run(res[2].join)
      res[1]['Content-Length'] = text.length
      res[2] = [text]
      res
    end
  end
end
