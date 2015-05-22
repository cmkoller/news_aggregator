require "sinatra"
require "csv"
require "pry"

def articles
  articles = {}
  CSV.foreach("articles.csv", headers: true) do |row|
    articles[row[0]] = { url: row[1], description: row[2] }
  end
  articles
end

get "/" do
  redirect "/articles"
end

get "/articles" do
  erb :index, locals: { articles: articles }
end

get "/articles/new" do
  erb :new
end

post "/articles" do
  title = params[:title]
  url = params[:url]
  description = params[:description]

  File.open("articles.csv", "a") do |f|
    f.puts("#{title}, #{url}, #{description}")
  end

  redirect "/articles"
end
