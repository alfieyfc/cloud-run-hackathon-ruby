require 'sinatra'

$stdout.sync = true

configure do
  set :port, 8080
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
