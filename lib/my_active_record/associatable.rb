require_relative 'searchable'
require 'active_support/inflector'

# Phase IVa
class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    self.class_name.constantize
  end

  def table_name
    self.model_class.table_name
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    @class_name = options[:class_name] || name.to_s.singularize.camelize
    @foreign_key = options[:foreign_key] || ("#{name.to_s.underscore}_id").to_sym
    @primary_key = options[:primary_key] || :id
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    @class_name = options[:class_name] || name.to_s.singularize.camelize
    @foreign_key = options[:foreign_key] || ("#{self_class_name.to_s.underscore}_id").to_sym
    @primary_key = options[:primary_key] || :id
  end
end

module Associatable
  # Phase IVb
  def belongs_to(name, options = {})
    options = BelongsToOptions.new(name, options = options)
    
    # when name is called, I want to get the "owner" of the current object
    define_method(name.to_s) do
      target_class = options.model_class
      target_class.find(self.send(options.foreign_key))
    end
    
    assoc_options[name] = options
  end

  def has_many(name, options = {})
    options = HasManyOptions.new(name, self, options = options)
    
    # when name is called, I want to get the object that the current object "owns"
    define_method(name.to_s) do
      target_class = options.model_class      
      target_class.where(options.foreign_key => self.send(options.primary_key))
    end
    
    assoc_options[name] = options
  end

  def assoc_options
    @assoc_options ||= {}
  end
end

class SQLObject
  # Mixin Associatable here...
  extend Associatable
  
end
