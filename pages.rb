require 'sinatra'
require 'andand'
require 'slim'

get '/' do
  slim :index
end

def paginate limit
  headers 'Accept-Ranges' => 'items'

  range = request.env['HTTP_RANGE'].andand.match(/(?<min>\d+)[ ]*-[ ]*(?<max>\d+)/)
  if range
    min, max = range['min'].to_i, range['max'].to_i
    if request.env['HTTP_RANGE_UNIT'] == 'items'
      if 0 <= max - min && max - min < (limit || Float::INFINITY)
        headers 'Link' => "</#{request.path}>; rel=\"next\"; items=\"#{1 + max}-#{1 + max*2 - min}\""
        headers 'Content-Range' => "items #{min}-#{max}/#{limit || '*'}"
        status 206
        yield min, max
      else
        status 416 # invalid range
      end
    else
      status 416
      body 'Unknown or unspecified Range-Unit (use "items")'
    end
  else
    yield
  end
end

get '/integers' do
  paginate 100 do |min, max|
    if min && max
      numbers = (min .. max).map { |i| "{ \"integer\": #{i} }" }
      body ('[' + numbers.join(', ') + ']')
    else
      status 413 # result too large
    end
  end
end

get '/alphabet' do
  paginate 26 do |min, max|
    min ||= 0
    max ||= 25
    body '[' + ( (min .. max).map { |i| '{ "letter": "' + (i+'a'.ord).chr + '"}' } ).join(', ') + ']'
  end
end
