# lib/util/argument_validator

=begin DESCRIPTION
  The ArgumentValidator provides a method to validate function arguments or
  other values in a consistent, extensible fashion.
=end

require 'util/util'

module RoundTable::Util
  module ArgumentValidator
    def validate_argument(arg, params = {})
      # Performs the requested validations, raising an ArgumentError on a
      # failed validation.
      # 
      # @param arg : the argument or value to validate
      # @param params (optional) : the additional terms for the validator,
      #   which determine what the value is checked against to determine
      #   the argument's validity.
      #   @key :allow_nil? (optional) : if set to false (the default), raises
      #     an error for a nil value. Defaults to false.
      #   @key :name (optional) : human-readable string describing the argument
      #     or value being validated. Defaults to "value".
      #   @key :nil? (optional) : if set to true, raises an error if the value
      #     is not nil. This overrides the behavior for the :allow_nil?
      #     parameter. Defaults to false.
      #   @key :type (optional) : if present, the value must be of the provided
      #     type. Due to implementation, this is ignored for a type of nil; use
      #     the nil? parameter instead to check for an (expected) nil value.
      
      raise ArgumentError.new("expected params to be Hash, received #{params.class}") unless
        params.is_a? Hash
      
      config = { :allow_nil? => false, :name => "value" }
      config.update(params) if params.is_a? Hash
      
      # validate not nil
      raise ArgumentError.new("expected #{config[:name]} not to be nil") unless
        config[:allow_nil?] or config[:nil?] or !(arg.nil?)
      
      # validate nil
      raise ArgumentError.new("expected #{config[:name]} to be nil") if
        config[:nil?] and !(arg.nil?)
      
      # validate type
      raise ArgumentError.new("expected #{config[:name]} to be #{[config[:type]].flatten.join(" or ")}, received #{arg.class}") unless
        config[:type].nil? or
        [config[:type]].flatten.inject(false) { |memo, type| memo ||= arg.is_a? type }
      
    end # validate_argument
  end # module ArgumentValidator
end # module RoundTable::Util