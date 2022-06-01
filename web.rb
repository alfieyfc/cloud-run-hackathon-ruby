require 'sinatra'

configure do
  set :bind, '0.0.0.0'
end

get '/' do
  'Let the battle begin!'
end

post '/' do

  puts JSON.parse(request.body.read)

  moves = ['F', 'T', 'L', 'R']
  moves.sample
end
