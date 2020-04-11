# frozen_string_literal: true

# bundle exec ruby conv.rb 3046308B30553044308F006100620043003100320033

require 'iconv'

def decode_sms(msg)
  Iconv.iconv('UTF8', 'UCS-2BE', [msg].pack('H*')).join.force_encoding('UTF-8')
rescue Iconv::IllegalSequence => e
  'Illegal message'
end

puts decode_sms ARGV[0] if $PROGRAM_NAME == __FILE__
