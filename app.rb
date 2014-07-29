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
    @messages_table = MessagesTable.new(GschoolDatabaseConnection::DatabaseConnection.establish(ENV["RACK_ENV"]))
    @comments_table = CommentsTable.new(GschoolDatabaseConnection::DatabaseConnection.establish(ENV["RACK_ENV"]))
  end

  get "/" do
    messages = @messages_table.all_messages
    comments = @comments_table.all_comments

    erb :home, locals: {messages: messages, comments: comments}
  end

  post "/messages" do
    message = params[:message]
    if message.length <= 140
      @messages_table.create_message(params[:message])
    else
      flash[:error] = "Message must be less than 140 characters."
    end
    redirect "/"
  end

  get "/messages/:id/edit" do
    message = @messages_table.display_message_edit(params[:id])
    erb :edit, locals: {message: message}
  end

  patch "/messages/:id" do
    message = params[:message]
    if message.length <= 140
      @messages_table.update_message(message, params[:id])
    else
      flash[:error] = "Message must be less than 140 characters."
      redirect back
    end
    redirect "/"
  end

  delete "/messages/delete/:id" do
    @messages_table.delete_message(params[:id])
    redirect "/"
  end

  post "/comments/:id" do
    @comments_table.add_comment(params[:comment],params[:id])
    redirect "/"
  end

  get "/display/:id" do
    messages = @messages_table.display_message(params[:id])
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