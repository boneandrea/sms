# frozen_string_literal: true

load 'AtCommand.rb'
load 'conv.rb'
require 'csv'

$ac = AtCommand.new

# SMSメールボックスを見て受信SMS個数を返す
# @return [int] SMS個数
def check_mailbox
  $ac.send("AT+CPMS=\"SM\"\n")
  response = $ac.read
  p response
  return unless response[-1] == 'OK'

  response[2].gsub(/.*: /, '').gsub(/ /, '').split(',')[0].to_i
end

# SMSを読み出す
# @return [int] SMS個数
#
def recv
  $ac.send("AT+CFUN=1\n")
  return unless $ac.ok?

  $ac.send("AT+CMGF=1\n")
  return unless $ac.ok?

  number_mails = check_mailbox
  return 0 if number_mails.zero?

  _recv number_mails
  number_mails
end

#
# Read mail(s)
# @param number_mails [int] メールの個数
# @return [void]
#
def _recv(number_mails)
  (1..number_mails).each do |num|
    $ac.send("AT+CMGR=#{num}\n")
    msgs = $ac.read

    cmgr_line = false
    msgs.each do |m|
      if cmgr_line
        cmgr_line = false
        puts decode_sms(m)
      end
      next unless m.match(/^\+CMGR: (.*)/)

      cmgr_line = true
      tel, timestamp = nil
      CSV.parse(Regexp.last_match(1)) do |c|
        tel = c[1]
        timestamp = c[3]
      end
      metadata = { from: tel, timestamp: timestamp }
      puts metadata
    end
  end
end

def remove(num)
  raise "Invalid number: #{num}" unless num

  $ac.send("AT+CMGD=#{num}\n")
  return unless $ac.ok?
end

number_mails = recv if $PROGRAM_NAME == __FILE__
puts "found #{number_mails} mail(s)"
remove 2 if (ARGV[0] == 'delete') && ($PROGRAM_NAME == __FILE__)
