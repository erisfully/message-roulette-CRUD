class CommentsTable

  attr_reader :database_connection

  def initialize(database_connection)
    @database_connection = database_connection
  end

  def all_comments
    database_connection.sql("SELECT * FROM comments")
  end

end
