class MessagesTable

  attr_reader :database_connection

  def initialize(database_connection)
    @database_connection = database_connection
  end

  def all_messages
    database_connection.sql("SELECT * FROM messages")
  end

  def create_message(message)
    database_connection.sql("INSERT INTO messages (message) VALUES ('#{message}')")
  end

  def display_message_edit (id)
    database_connection.sql("SELECT * FROM messages WHERE id = '#{id}'").first
  end


  def display_message (id)
    database_connection.sql("SELECT * FROM messages WHERE id = '#{id}'")
  end

  def update_message (message, id)
    database_connection.sql("UPDATE messages SET message = '#{message}' WHERE id='#{id}'")
  end

  def delete_message (id)
    database_connection.sql("DELETE FROM messages WHERE id = '#{id}'")
  end
end

