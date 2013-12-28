require 'sinatra'
require 'andand'

get '/' do
  "Hello World!"
end

get '/integers' do
  range = request.env['HTTP_CONTENT_RANGE'].andand.match(/(?<min>\d+)[ ]*-[ ]*(?<max>\d+)/)
  if range
    min, max = range['min'].to_i, range['max'].to_i
    if request.env['HTTP_RANGE_UNIT'] == 'items'
      headers 'Link' => "</integers>; rel=\"next\"; items=\"#{1 + max}-#{1 + max*2 - min}\""
      body '[' + (min .. max).to_a.join(', ') + ']'
    else
      status 416
      body 'Unknown or unspecified Range-Unit (use "items")'
    end
  else
    status 413 # request entity too large
  end
end
