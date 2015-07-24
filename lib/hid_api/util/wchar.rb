module HidApi
  module Util
    module WCHAR
      WCHAR_T_WIDTH = RUBY_PLATFORM =~ /mswin/i ? 2 : 4

      # Maps a WCHAR_T_WIDTH to the corresponding Array#pack character width
      FORMATS = {
        2 => 'S',
        4 => 'L'
      }

      # Maps a WCHAR_T_WIDTH to the corresponding string encoding
      ENCODINGS = {
        2 => 'utf-16le',
        4 => 'utf-32le'
      }

      def read_wchar_string max_chars=nil
        buffer = []
        offset = 0
        loop do
          pointer = self + (offset * WCHAR_T_WIDTH)
          char = pointer.send("read_uint#{WCHAR_T_WIDTH * 8}")
          break if char.zero?
          buffer << char
          offset += 1
        end
        buffer.pack("#{FORMATS[WCHAR_T_WIDTH]}*").force_encoding(ENCODINGS[WCHAR_T_WIDTH]).encode('utf-8')
      end
    end
  end
end