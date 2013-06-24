module HasMaskedField
  extend ActiveSupport::Concern
     
  module ClassMethods
    def has_masked_field field_name
      
    
      # don't overwrite field value with a masked value
      self.send(:define_method, "#{field_name}=", lambda do |new_val|
        return if self[field_name] && new_val && new_val['#']
        self[field_name]= new_val
      end)
      self.send(:public, "#{field_name}=")

      # fully mask when you call it
      self.send(:define_method, "#{field_name}", lambda do
        self[field_name] ? self[field_name.to_sym].gsub(/./, '#') : nil
      end)
      self.send(:public, "#{field_name}")

      # masked version
      self.send(:define_method, "#{field_name}_masked", lambda do
        val = self[field_name]
        val ? val[0, val.length - 4].gsub(/./, '#') + val[val.length - 4, val.length] : nil
      end)
      self.send(:public, "#{field_name}_masked")

      # fully cleared version
      self.send( :define_method, "#{field_name}_clear", lambda do
        self[field_name]
      end)
      self.send(:public,  "#{field_name}_clear")

    end
  end
end

ActiveRecord::Base.send :include, HasMaskedField