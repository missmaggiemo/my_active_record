require_relative 'db_connection'
require_relative 'sql_object'
require_relative 'relation'

module Searchable
  
  def where(params)    
    results = Relation.new(self, params)
    
    # hoe do I make them chain?
    
    # parse_all(results)
  end
  
end


class SQLObject
  # Mixin Searchable here...
  extend Searchable
  
end
