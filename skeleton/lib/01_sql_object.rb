require_relative 'db_connection'
require 'active_support/inflector'
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.
require 'byebug'
class SQLObject

  def self.columns
    if @columns
      return @columns
    end

    cols_table = DBConnection.execute2(<<-SQL).first
      SELECT
        *
      FROM
        #{self.table_name}
      LIMIT
        0
    SQL
    
    @columns = cols_table.map!(&:to_sym)
  end

  def self.finalize!
    self.columns.each do |col|
      define_method(col) do
        instance_variable_get("@#{col}")
      end

      define_method("#{col}=") do |new_val|
        old_val = "@#{col}"
        instance_variable_set(old_val, new_val)
      end
    end

    self.attributes.each do |k, v|
      define_method(k) do
        v
      end
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    name = self.to_s.downcase
    "#{name}s"
  end

  def self.all
    @SQLObject ||= []
  end

  def self.parse_all(results)
    results.each do |k, v|
      i = 0
      while i < results.length
        define_method(k) do |v|
          self[i].k = v
        end
        i += 1
      end
    end
    # expect(cats[i].name).to eq(hashes[i][:name])
    # expect(cats[i].owner_id).to eq(hashes[i][:owner_id])
  end

  def self.find(id)
    # ...
  end

  def initialize(params = {})
    
  end

  def attributes

    @attributes = {}
  end

  def attribute_values
    # ...
  end

  def insert
    # ...
  end

  def update
    # ...
  end

  def save
    insert
  end
end
