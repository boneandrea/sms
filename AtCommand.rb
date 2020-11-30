# frozen_string_literal: false

require 'serialport'
require 'dotenv'
Dotenv.load

# ATCommand
class AtCommand
  def self.fin_proc
    proc { @sp.close }
  end

  def initialize
    @sp = SerialPort.new(ENV['device'])
    @sp.set_modem_params(115_200, 8, 1, 0)
    ObjectSpace.define_finalizer(self, self.class.fin_proc)
  rescue Errno::EBUSY => e
    p e
    exit
  end

  def ok?
    sleep(0.5)
    line = @sp.readpartial(1024).delete("\r").split("\n")
    puts "<< #{line}"
    line[-1] == 'OK'
  end

  def prompt?
    sleep(0.5)
    line = @sp.readpartial(1024).delete("\r").split("\n")
    line[-1] == '> '
  end

  def sent?
    sleep(5)
    line = @sp.readpartial(1024).delete("\r").split("\n")
    puts "<< #{line}"
    line[1] != 'ERROR'
  end

  def read
    sleep(0.5)
    @sp.readpartial(1024).delete("\r").split("\n")
  end

  def send(msg)
    @sp.write(msg)
    puts ">> #{msg}"
  end

  def pack(msg)
    cpmsg = ''
    msg.each_codepoint { |cp| cpmsg << format('%04x', cp) }
    cpmsg
  end
end
