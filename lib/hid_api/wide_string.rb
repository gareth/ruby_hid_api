require 'ffi'

module HidApi
  class WideString
    extend FFI::DataConverter
    native_type FFI::Type::POINTER

    class << self
      def from_native value, context
        return nil if value.null?
        value.read_wchar_string
      end
    end
  end
end