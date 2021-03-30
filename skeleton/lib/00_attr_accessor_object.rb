class AttrAccessorObject
  def self.my_attr_accessor(*names)
    names.each do |name|
      define_method(name) do
        instance_variable_get("@#{name}")
      end

      define_method("#{name}=") do |new_val|
        old_val = "@#{name}"
        instance_variable_set(old_val, new_val)
      end
    end
  end
end
