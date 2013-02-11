require 'sinatra'
require 'sinatra/cookies'

require_relative 'lib/pics'

get '/' do
  cookies[:to_exclude] ||= ""
  @to_guess = Pics.random(:to_exclude => to_array(cookies[:to_exclude]))
  @pics = (Pics.get(:gender => @to_guess.gender, :quantity => 3, :pick => @to_guess) << @to_guess).shuffle
  @total = Pics.total
  @progress = cookies[:right].to_i
  erb :main
end

post '/guess' do
  cookies[:right] = add_to_string(1, cookies[:right]) if params["correct"] == params["guess"]
  cookies[:to_exclude] = add_to_exclude_to_list(cookies[:to_exclude], params[:id])
  redirect '/'
end

def add_to_exclude_to_list(list, id)
  return id.to_s if list == ""
  return "#{list},#{id}"
end

def add_to_string val, string
  return 0 if string.nil?
  return (string.to_i + 1).to_s
end

def to_array string
  return [] if string == ""
  return string.split(",").map(&:to_i)
end

