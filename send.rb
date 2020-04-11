# frozen_string_literal: true

load 'AtCommand.rb'

require 'dotenv'
Dotenv.load

# send a sms
# @param msg [String] 送信文字列
# @return [void]
def mysend(msg)
  raise 'number is not set' unless ENV['phone_number']
  return false unless ENV['phone_number']

  phone_number = ENV['phone_number']
  ac = AtCommand.new

  ac.send("AT\n")
  return unless ac.ok?

  ac.send("AT+CFUN=1\n")
  return unless ac.ok?

  ac.send("AT+CMGF=1\n")
  return unless ac.ok?

  ac.send("AT+CSMP=1,167,0,8\n")
  return unless ac.ok?

  ac.send("AT+CSCS=\"UCS2\"\n")
  return unless ac.ok?

  ac.send("AT+CSCA?\n")
  return unless ac.ok?

  ac.send("AT+CMGS=\"#{phone_number}\"\n")
  return unless ac.prompt?

  puts msg
  packed_msg = ac.pack(msg)

  ac.send(packed_msg + 26.chr) # 26.chr == ctrl-Z
  return nil unless ac.sent?
end

mysend(ARGV[0]) if $PROGRAM_NAME == __FILE__
