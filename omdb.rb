require 'sinatra'
require 'sinatra/reloader'
require 'typhoeus'
require 'json'

get '/' do
  html = %q(
  <html><head><title>Movie Search</title></head><body>
  <h1>Find a Movie!</h1>
  <form accept-charset="UTF-8" action="/result" method="post">
    <label for="movie">Search for:</label>
    <input id="movie" name="movie" type="text" />
    <input name="commit" type="submit" value="Search" /> 
  </form></body></html>
  )
end

post '/result' do
  search_str = params[:movie]

  #searching through OMDB API
  response = Typhoeus.get("www.omdbapi.com", :params => {:s => search_str})
  #parsing the hash
  result = JSON.parse(response.body)

  html_str = "<html><head><title>Movie Search Results</title></head><body><h1>Movie Results</h1>\n<ul>"

  #iterating through the hash and retrieving the movie Title, Year and ID
  result["Search"].each do |movie| 

    html_str += "<li><a href=/poster/#{movie['imdbID']}>#{movie['Title']}: #{movie['Year']}</a></li>"

  end

  html_str += "</ul></body></html>"

  # Modify the html output so that a list of movies is provided.
  
  # html_str += "<li>#{response.body}</li></ul></body></html>"

end

get '/poster/:imdb' do |imdb_id|
  # Make another api call here to get the url of the poster.

  response2 = Typhoeus.get("www.omdbapi.com", :params => {:i => imdb_id})
  result2 = JSON.parse(response2.body)

  # picture = result2.map { |item| item['Poster'] }

  html_str = "<html><head><title>Movie Poster</title></head><body><h1>Movie Poster</h1>\n"
  html_str = "<h2><img src='#{result2['Poster']}'><h2>"
  html_str += '<br /><a href="/">New Search</a></body></html>'

end

