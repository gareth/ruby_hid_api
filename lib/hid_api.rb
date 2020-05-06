require "ffi"

# A Ruby wrapper around the C `hidapi` library
module HidApi
  class HidError < StandardError; end

  HIDAPI_LIBS = %w(hidapi hidapi-libusb hidapi-hidraw).freeze

  extend FFI::Library
  ffi_lib HIDAPI_LIBS

  autoload :Deprecated, "hid_api/deprecated"
  autoload :Device,     "hid_api/device"
  autoload :DeviceInfo, "hid_api/device_info"
  autoload :Util,       "hid_api/util"
  autoload :VERSION,    "hid_api/version"
  autoload :WideString, "hid_api/wide_string"

  typedef DeviceInfo.auto_ptr, :hid_device_info
  typedef WideString, :wide_string
  typedef Device, :device
  typedef :int, :vendor_id
  typedef :int, :product_id
  typedef :int, :serial_number
  typedef :int, :length
  typedef :int, :timeout

  attach_function :hid_init, [], :int
  attach_function :hid_exit, [], :int
  attach_function :hid_enumerate, [:int, :int], :hid_device_info
  attach_function :hid_free_enumeration, [:hid_device_info], :void
  attach_function :hid_open, [:vendor_id, :product_id, :serial_number], :device
  attach_function :hid_open_path, [:string], :device
  attach_function :hid_write, [:device, :buffer_in, :length], :int
  attach_function :hid_read_timeout, [:device, :buffer_out, :length, :timeout], :int
  attach_function :hid_read, [:device, :buffer_out, :length], :int
  attach_function :hid_set_nonblocking, [:device, :int], :int
  attach_function :hid_send_feature_report, [:device, :buffer_in, :int], :int
  attach_function :hid_get_feature_report, [:device, :buffer_out, :int], :int
  attach_function :hid_close, [:device], :void
  attach_function :hid_get_manufacturer_string, [:device, :buffer_out, :length], :int
  attach_function :hid_get_product_string, [:device, :buffer_out, :length], :int
  attach_function :hid_get_serial_number_string, [:device, :buffer_out, :length], :int
  attach_function :hid_get_indexed_string, [:device, :int, :buffer_out, :length], :int
  # hid_error will always return a nil except on Windows
  attach_function :hid_error, [:device], WideString

  class << self
    alias init hid_init
    alias exit hid_exit
    alias enumerate hid_enumerate
    alias free_enumeration hid_free_enumeration
    def open(vendor_id, product_id, serial_number = nil)
      device = hid_open(vendor_id, product_id, serial_number || 0)
      if device.null?
        error = format(
          "Unable to open %s",
          [vendor_id, product_id, serial_number].inspect
        )
        raise HidError, error
      end
      device
    end

    def open_path(path)
      device = hid_open_path(path)
      raise HidError, "Unable to open #{path.inspect}" if device.null?
      device
    end
  end
end

# Attempts to extend some core FFI classes with platform-aware string-handling
FFI::AbstractMemory.include(HidApi::Util::WCHAR)
