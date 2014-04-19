require_relative 'associatable'

# Phase V
module Associatable
  # Remember to go back to associatable to write ::assoc_options

  def has_one_through(name, through_name, source_name)
            
    define_method(name.to_s) do
      
      through_options = self.class.assoc_options[through_name]
      through_foreign_key = through_options.foreign_key
      through_primary_key = through_options.primary_key
      through_model_class = through_options.model_class
      
      through_model = through_model_class.where(through_primary_key => 
                                                self.send(through_foreign_key)).first
      through_model.send(source_name)
    end
      
  end
end
