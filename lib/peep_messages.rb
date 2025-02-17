require 'pg'

class PeepMessages
  attr_reader :message, :date
  
  def initialize(message = '', date = '' )
    @message = message
    @date = date
  end 

  def self.all
    if ENV['ENVIRONMENT'] == 'test'
      connection = PG.connect(dbname: 'chitter_test')
    else
      connection = PG.connect(dbname: 'chitter')
    end
    
    p result = connection.exec("SELECT * FROM peeps")
    
    result.map do | peep | 
     p PeepMessages.new( message: peep['message'], date: peep['date'])
    end 
  end 

  def self.create(message:, date:)
    if ENV['ENVIRONMENT'] == 'test'
      connection = PG.connect(dbname: 'chitter_test')
    else
      connection = PG.connect(dbname: 'chitter')
    end
    connection.exec("INSERT INTO peeps (message) VALUES('#{message}', '#{date}') RETURNING message, date")
  end

end 