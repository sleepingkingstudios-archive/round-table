# lib/util/argument_validator

=begin DESCRIPTION
  The ArgumentValidator provides a method to validate function arguments or
  other values in a consistent fashion.
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
      #     an error for a nil value. If used with the :type param, returns
      #     true even if NilClass is not among the listed types. Defaults to
      #     false.
      #   @key :as (optional) : human-readable string describing the argument
      #     or value being validated. Defaults to "value".
      #   @key :nil? (optional) : if set to true, raises an error if the value
      #     is not nil. This overrides the behavior for the :allow_nil?
      #     parameter. Defaults to false.
      #   @key :respond_to? (optional) : if present, the value must respond to
      #     the given message. If an array is given, the value must respond to
      #     all of the given messages.
      #   @key :type (optional) : if present, the value must be of the provided
      #     type. Due to implementation, this is ignored for a type of nil; use
      #     the nil? parameter instead to check for an (expected) nil value. If
      #     an array is given, the value must be one of the given types.
      
      raise ArgumentError.new("expected params to be Hash, received #{params.class}") unless
        params.is_a? Hash
      
      config = { :allow_nil? => false, :as => "value" }
      config.update(params) if params.is_a? Hash
      
      # validate not nil
      raise ArgumentError.new("expected #{config[:as]} not to be nil") unless
        config[:allow_nil?] or config[:nil?] or !(arg.nil?)
      
      # validate nil
      raise ArgumentError.new("expected #{config[:as]} to be nil") if
        config[:nil?] and !(arg.nil?)
      
      # validate responds to messages
      [config[:respond_to?]].flatten.each do |message|
        raise ArgumentError.new("expected #{config[:as]} to respond to :#{message}") unless
          arg.respond_to? message
      end unless config[:respond_to?].nil?
      
      # validate type
      raise ArgumentError.new("expected #{config[:as]} to be #{[config[:type]].flatten.join(" or ")}, received #{arg.class}") unless
        config[:type].nil? or
        (arg.nil? and config[:allow_nil?]) or
        [config[:type]].flatten.inject(false) { |memo, type| memo || arg.is_a?(type) }      
    end # validate_argument
  end # module ArgumentValidator
end # module RoundTable::Util