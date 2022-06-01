require 'sinatra'

get '/' do
  'Let the battle begin!'
end

post '/' do

  puts JSON.parse(request.body.read)

  moves = ['F', 'T', 'L', 'R']
  moves.sample
end
