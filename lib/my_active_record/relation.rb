require_relative 'db_connection'
require_relative 'sql_object'

class Relation
  
  def initialize(class_name, params)
    @class_name = class_name
    @table_name = class_name.table_name
    @where_info ||= [params.keys.map { |attribute| "#{attribute.to_s} = ?" }.join(' AND ')]
    @where_vals ||= params.values
  end
  
  def where(params)
    # adds other "where" query info...
    @where_info << params.keys.map { |attribute| "#{attribute.to_s} = ?" }.join(' AND ')
    @where_vals += params.values
    self
  end
  
  def parse_all(results)
    # parses results
    results.map do |result|
      @class_name.new(result)
    end
  end
  
  def run_execute
    # execute _all_ of the queries
    
    results = DBConnection.execute(<<-SQL, @where_vals)
      SELECT 
        *
      FROM 
        #{@table_name}
      WHERE 
        #{@where_info.join(' AND ')}
    SQL
    
    parse_all(results)
  end
  
  def first
    run_execute.first
  end
  
  def last
    run_execute.last
  end
  
  def each(&block)
    run_execute.each(&block)
  end
  
  def map(&block)
    arr = run_execute
    arr.map(&block)
  end
  
  def length
    run_execute.length
  end
  
  def to_a
    run_execute
  end
  
  def inspect
    run_execute
  end
  
  def [](n)
    run_execute[n]
  end
  
  # collect all the "where"s and the info in it, when it executes, join all the info with "AND"s, execute!
  
  # where_info = params.keys.map { |attribute| "#{attribute.to_s} = ?" }.join(' AND ')
#   where_vals = params.values

# User.all.where(:id=1).where(:chicken=true)


        
end