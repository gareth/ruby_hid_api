module HidApi
  module Util
    # A utility module that provides simple (maybe naive) platform-dependent
    # support for wide characters
    module WCHAR
      WCHAR_T_WIDTH = ::RUBY_PLATFORM =~ /mswin/i ? 2 : 4

      # Maps a WCHAR_T_WIDTH to the corresponding Array#pack character width
      FORMATS = {
        2 => "S",
        4 => "L"
      }.freeze

      # The platform-specific Array#pack format for wide characters
      FORMAT = FORMATS[WCHAR_T_WIDTH].freeze

      # Maps a WCHAR_T_WIDTH to the corresponding string encoding
      ENCODING = {
        2 => "utf-16le",
        4 => "utf-32le"
      }.freeze

      # The platform-specific String encoding that can handle wide characters
      ENCODING = ENCODINGS[WCHAR_T_WIDTH].freeze

      def read_wchar_string(_max_chars = nil)
        buffer = []
        offset = 0
        loop do
          pointer = self + (offset * WCHAR_T_WIDTH)
          char = pointer.send("read_uint#{WCHAR_T_WIDTH * 8}")
          break if char.zero?
          buffer << char
          offset += 1
        end
        buffer.pack("#{FORMAT}*").force_encoding(ENCODING).encode("utf-8")
      end
    end
  end
end
