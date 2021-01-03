require "ffi"

module HidApi
  # An FFI pointer extended to expose HID device functionality
  class Device < FFI::Pointer
    extend Deprecated
    extend FFI::DataConverter
    native_type FFI::Type::POINTER

    def self.from_native(value, _ctx)
      new(value)
    end

    def close
      HidApi.hid_close(self)
    end

    def nonblocking=(int)
      HidApi.hid_set_nonblocking self, int
    end
    deprecated_alias :set_nonblocking, :nonblocking=

    def manufacturer_string
      get_buffered_string :manufacturer
    end
    deprecated_alias :get_manufacturer_string, :manufacturer_string

    def product_string
      get_buffered_string :product
    end
    deprecated_alias :get_product_string, :product_string

    def serial_number_string
      get_buffered_string :serial_number
    end
    deprecated_alias :get_serial_number_string, :serial_number_string

    def read(length)
      buffer = clear_buffer length
      with_hid_error_handling do
        HidApi.hid_read self, buffer, buffer.size
      end
      buffer
    end

    def read_timeout(length, timeout)
      buffer = clear_buffer length
      with_hid_error_handling do
        HidApi.hid_read_timeout self, buffer, buffer.size, timeout
      end
      buffer
    end

    def write(data)
      buffer = clear_buffer data.length
      case data
      when String then buffer.put_bytes 0, data
      when Array then buffer.put_array_of_char 0, data
      end

      with_hid_error_handling do
        HidApi.hid_write self, buffer, buffer.size
      end
    end

    def get_feature_report(_data)
      raise NotImplementedError
    end

    def send_feature_report(_data)
      raise NotImplementedError
    end

    def error
      # NOTE: hid_error is only implemented on Windows systems and returns nil
      # on other platforms
      HidApi.hid_error(self)
    end

    private

    def clear_buffer(length)
      return FFI::MemoryPointer.new(:char, length)
    end

    def get_buffered_string(field)
      buffer = clear_buffer 255
      HidApi.send "hid_get_#{field}_string", self, buffer, buffer.size
      WideString.from_native(buffer)
    end

    def with_hid_error_handling
      raise ArgumentError, "Block required" unless block_given?
      yield.tap do |result|
        raise HidError, error if result == -1
      end
    end
  end
end
