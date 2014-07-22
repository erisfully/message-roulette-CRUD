require "sinatra"
require "active_record"
require "gschool_database_connection"
require "rack-flash"

class App < Sinatra::Application
  enable :sessions
  use Rack::Flash

  def initialize
    super
    @database_connection = GschoolDatabaseConnection::DatabaseConnection.establish(ENV["RACK_ENV"])
  end

  get "/" do
    messages = @database_connection.sql("SELECT * FROM messages")
    comments = @database_connection.sql("SELECT * FROM comments")

    erb :home, locals: {messages: messages, comments: comments}
  end

  post "/messages" do
    message = params[:message]
    if message.length <= 140
      @database_connection.sql("INSERT INTO messages (message) VALUES ('#{message}')")
    else
      flash[:error] = "Message must be less than 140 characters."
    end
    redirect "/"
  end

  get "/messages/:id/edit" do
    message = @database_connection.sql("SELECT * FROM messages WHERE id = '#{params[:id]}'").first
    erb :edit, locals: {message: message}
  end

  patch "/messages/:id" do
    message = params[:message]
    if message.length <= 140
      @database_connection.sql("UPDATE messages SET message = '#{message}' WHERE id='#{params[:id]}'")
    else
      flash[:error] = "Message must be less than 140 characters."
      redirect back
    end
    redirect "/"
  end

  delete "/messages/delete/:id" do
   @database_connection.sql("DELETE FROM messages WHERE id = '#{params[:id]}'")
    redirect "/"
  end

  post "/comments/:id" do
    @database_connection.sql("INSERT INTO comments (comment, message_id) values ('#{params[:comment]}', #{params[:id]})")
    redirect "/"
  end

  get "/display/:id" do
    messages = @database_connection.sql("SELECT * FROM messages WHERE id = '#{params[:id]}'")
    comments = @database_connection.sql("SELECT * FROM comments")

    erb :display, locals: {messages: messages, comments: comments}
  end



end