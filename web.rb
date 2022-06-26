require 'sinatra'

$stdout.sync = true

configure do
  set :port, 8080
  set :bind, '0.0.0.0'
end

get '/' do
  'Let the battle begin!'
end

$running_count = 0

post '/' do
  @data = JSON.parse(request.body.read)
  hit_analysis

  case $mode
  when "running"
    case $running_count
    when 0
      $running_count = 3
      return ["L", "R"].sample
    when 1
      $running_count = 0
      $mode = "attacking"
      return "F"
    when 2
      $running_count -= 1
      return ["L", "R"].sample
    when 3
      $running_count -= 1
      return "F"
    end
  when "attacking"
    if target.empty?
      return ["L", "R", "F"].sample
    else
      return "T"
    end
  end
end

def arena_info(direction = "x", full_info = true)
  return @data["arena"]["dims"] if full_info
  if direction == "x"
    @data["arena"]["dims"][0]
  else
    @data["arena"]["dims"][1]
  end
end

def state
  @_state ||- @data["arena"]["state"]
end

def self_info
  @_self_info ||= state["https://cloud-run-hackathon-ruby-22mk7ghtqq-uc.a.run.app"] || state["https://YOUR_SERVICE_URL"]
end

def current_x
  @_current_x ||= self_info["x"]
end

def current_y
  @_current_y || self_info["y"]
end

def hit_analysis
  if self_info["wasHit"]
    $hit_count ||= ($hit_count + 1)
  else
    $hit_count = 0
  end

  $mode = "running" if $hit_count >= 3
end

def facing
  @_facing ||= self_info["direction"]
end

def search_x(facing)
  @_search_x ||= case facing
  when "N" then [current_x]
  when "W" then [(current_x - 2)..current_x]
  when "S" then [current_x]
  when "E" then [current_x..(current_x + 2)]
  end
end

def search_y(facing)
  @_search_y ||= case facing
  when "N" then [(current_y - 2)..current_y]
  when "W" then [current_y]
  when "S" then [current_y..(current_y + 2)]
  when "E" then [current_y]
  end
end

def target
  state.select do |k, v|
    case facing
    when "N", "S"
     v["x"] == current_x && search_y.include?(v["y"])
    when "W", "E"
     v["y"] == current_y && search_x.include?(v["x"])
    end
  end
end
