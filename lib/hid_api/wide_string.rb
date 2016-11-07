require "ffi"

module HidApi
  # An FFI data converter that marshalls data from specific device fields via
  # the WCHAR utility class
  class WideString
    extend FFI::DataConverter
    native_type FFI::Type::POINTER

    class << self
      def from_native(value, _context)
        return nil if value.null?
        value.read_wchar_string
      end
    end
  end
end
