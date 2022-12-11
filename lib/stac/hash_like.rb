# frozen_string_literal: true

require 'json'

module STAC
  # Enables included class to behave like Hash.
  module HashLike
    # Extra fields that do not belong to the STAC core specification.
    attr_reader :extra

    # When there is an attribute with the given name, returns the attribute value.
    # Otherwise, calls `extra [key]`.
    def [](key)
      if respond_to?(key) && method(key).arity.zero?
        public_send(key)
      else
        extra[key.to_s]
      end
    end

    # When there is an attribute writer with the given name, assigns the value to the attribute.
    # Otherwise, adds the given key-value pair to `extra` hash.
    def []=(key, value)
      method = "#{key}="
      if respond_to?(method)
        public_send(method, value)
      else
        extra[key.to_s] = value
      end
    end

    # Sets the attributes (like ActiveModel::AttributeAssignment#assign_attributes)
    # or merges the args into `extra` hash (like Hash#update).
    def update(**options)
      options.each do |key, value|
        self[key] = value
      end
      self
    end

    def to_hash # :nodoc:
      to_h
    end

    # Serializes self to a Hash.
    def to_h
      extra
    end

    # Serializes self to a JSON string.
    def to_json(...)
      to_h.to_json(...)
    end

    # Returns `true` if all of the followings are true:
    # - the given object is an instance of tha same class
    # - `self.to_hash == other.to_hash`
    #
    # Otherwise, returns `false`.
    def ==(other)
      other.instance_of?(self.class) && to_hash == other.to_hash
    end

    # Returns a copy of self by serializes self to a JSON and desirializes it by `.from_hash`.
    def deep_dup
      unless self.class.respond_to?(:from_hash)
        raise NotImplementedError, "#{self.class} must implement `.from_hash(hash)` to use `HashLike#deep_dup`"
      end

      hash = JSON.parse(to_json)
      self.class.from_hash(hash)
    end
  end
end
