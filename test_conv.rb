require 'rspec/expectations'
# frozen_string_literal: true

include RSpec::Matchers
load 'conv.rb'

expect(decode_sms('6d7775237269')).to eq '海産物'
