require 'ffi'

module HidApi
  # Represents the hid_device_info struct returned as part of
  # the HidApi::hid_enumerate operation
  #
  # Because the struct acts as a linked list, every item represents both a
  # device in the enumeration AND an Enumerable representing the rest of the
  # list.
  class DeviceInfo < FFI::Struct
    include Enumerable

    def self.release(pointer)
      HidApi.hid_free_enumeration(pointer) unless pointer.null?
    end

    # Struct layout from http://www.signal11.us/oss/hidapi/hidapi/doxygen/html/structhid__device__info.html
    layout  :path,                :string,            # char * path
            :vendor_id,           :ushort,            # unsigned short vendor_id
            :product_id,          :ushort,            # unsigned short product_id
            :serial_number,       WideString,         # wchar_t * serial_number
            :release_number,      :ushort,            # unsigned short release_number
            :manufacturer_string, WideString,         # wchar_t * manufacturer_string
            :product_string,      WideString,         # wchar_t * product_string
            :usage_page,          :ushort,            # unsigned short usage_page
            :usage,               :ushort,            # unsigned short usage
            :interface_number,    :int,               # int interface_number
            :next,                DeviceInfo.auto_ptr # struct hid_device_info * next

    # Makes the struct members available as methods
    layout.members.each do |f|
      define_method(f) do
        self[f]
      end
    end

    def inspect
      product_string.tap do |s|
        s << " (%s)" % path unless path.empty?
      end
    end

    # Exposes the linked list structure in an Enumerable-compatible format
    def each
      return enum_for(:each) unless block_given?

      pointer = self
      loop do
        break if pointer.null?
        yield pointer
        pointer = pointer.next
      end
    end
  end
end