##Author => Guillermo Guerrero Ibarra
##Email => guillermo@guerreroibarra.com

require "rubygems"
require "json"
require "net/http"
require "uri"

#CONSTANTS
MYSTERY_URL = 'http://which-technical-exercise.herokuapp.com/api/guillermo@guerreroibarra.com/directions'
DIRECTIONS_ARRAY = ["NORTHBOUND", "EASTBOUND", "SOUTHBOUND", "WESTBOUND"]
FORWARD_INC = {"NORTHBOUND" => {'x' => 0, 'y' => 1}, 
               "SOUTHBOUND" => {'x' => 0, 'y' => -1}, 
               "EASTBOUND" =>   {'x' => 1, 'y' => 0},
               "WESTBOUND" =>  {'x' => -1, 'y' => 0}}

TURN_LEFT = -1
TURN_RIGHT = 1

def http_get(string_url)
  uri = URI.parse(string_url)

  http = Net::HTTP.new(uri.host, uri.port)
  request = Net::HTTP::Get.new(uri.request_uri)

  response = http.request(request)
end

def resolve_mystery(json_directions)
  puts "Mystery => #{json_directions}"
  current_direction = DIRECTIONS_ARRAY.index("NORTHBOUND")
  current_position = {'x' => 0, 'y' => 0}

  if json_directions.has_key?('directions')
    directions = json_directions['directions'] 
    
    directions.each do |direction|      
      case direction.downcase
      when "forward"
        current_position['x'] += FORWARD_INC[DIRECTIONS_ARRAY[current_direction]]['x']
        current_position['y'] += FORWARD_INC[DIRECTIONS_ARRAY[current_direction]]['y']      
      when "right"
        current_direction += TURN_RIGHT
        current_direction = current_direction % DIRECTIONS_ARRAY.size
      when "left"
        current_direction += TURN_LEFT        
        current_direction = current_direction % DIRECTIONS_ARRAY.size
      end
    end 
    
    puts "Final position => #{current_position.inspect}"      
    return http_get("http://which-technical-exercise.herokuapp.com/api/dasdasda@dadas.com/location/#{current_position['x']}/#{current_position['y']}")
  else
    puts 'json has not key directions'  
  end
end

puts "Begin mystery!"
response = http_get(MYSTERY_URL)
 
if response.code == "200"
  json_path = JSON.parse(response.body)  
  response_mystery = resolve_mystery(json_path)
  
  if response_mystery.code == "200"
    puts response_mystery.body
  else
    puts 'Failed revolving mystery'
  end
else
  puts "Failed getting => #{MYSTERY_URL}"
end

puts "End mystery!"