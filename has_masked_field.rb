module HasMaskedField
  extend ActiveSupport::Concern

  module ClassMethods
    def has_masked_field field_name

      # TODO add after_validation hook to move the error over

      # keep our unmasked reader/writer fields
      alias_method "#{field_name}_unmasked_writer", "#{field_name}="
      alias_method "#{field_name}_unmasked_reader", "#{field_name}"

      # don't overwrite field value with a masked value
      self.send(:define_method, "#{field_name}=", lambda do |new_val|
        return if new_val && new_val['#']
        self.send("#{field_name}_unmasked_writer", new_val)
      end)
      self.send(:public, "#{field_name}=")

      # fully mask when you call it
      self.send(:define_method, "#{field_name}", lambda do
        val = self.send("#{field_name}_unmasked_reader")
        return val if val.blank?
        val.gsub(/./, '#')
      end)
      self.send(:public, "#{field_name}")

      # masked version
      self.send(:define_method, "#{field_name}_masked", lambda do
        val = self.send("#{field_name}_unmasked_reader")
        return val if val.blank?
        val && !val.nil? ? val[0, val.length - 4].gsub(/./, '#') + val[val.length - 4, val.length] : nil
      end)
      self.send(:public, "#{field_name}_masked")

      # fully unmasked version
      self.send( :define_method, "#{field_name}_clear", lambda do
        self.send("#{field_name}_unmasked_reader")
      end)
      self.send(:public,  "#{field_name}_clear")

    end
  end
end

ActiveRecord::Base.send :include, HasMaskedField
