require "sinatra"
require "active_record"
require "gschool_database_connection"
require "rack-flash"
require "./lib/messages_table"
require "./lib/comments_table"

class App < Sinatra::Application
  enable :sessions
  use Rack::Flash

  def initialize
    super
    @message_table = MessagesTable.new(GschoolDatabaseConnection::DatabaseConnection.establish(ENV["RACK_ENV"]))
    @comments_table = CommentsTable.new(GschoolDatabaseConnection::DatabaseConnection.establish(ENV["RACK_ENV"]))
  end

  get "/" do
    messages = @message_table.all_messages
    comments = @comments_table.all_comments

    erb :home, locals: {messages: messages, comments: comments}
  end

  post "/messages" do
    message = params[:message]
    if message.length <= 140
      @message_table.create_message(params[:message])
    else
      flash[:error] = "Message must be less than 140 characters."
    end
    redirect "/"
  end

  get "/messages/:id/edit" do
    message = @message_table.display_message(params[:id])
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
    messages = @message_table.display_message(params[:id])
    comments = @comments_table.all_comments

    erb :display, locals: {messages: messages, comments: comments}
  end

  patch "/likes/:id" do
    @database_connection.sql("UPDATE messages SET likes = (likes +1) WHERE id = '#{params[:id]}'")
    redirect "/"
  end

  patch "/unlikes/:id" do
    @database_connection.sql("UPDATE messages SET likes = (likes -1) WHERE id = '#{params[:id]}'")
    redirect "/"
  end

end