require "sinatra"
require "csv"
require "pry"
require "pg"

def db_connection
  begin
    connection = PG.connect(dbname: "news_aggregator_development")
    yield(connection)
  ensure
    connection.close
  end
end

def articles
  db_connection do |conn|
    conn.exec("SELECT * FROM articles;")
  end
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

  db_connection do |conn|
    conn.exec_params("INSERT INTO articles (title, url, description)
      VALUES ($1, $2, $3)", [title, url, description])
  end

  redirect "/articles"
end
