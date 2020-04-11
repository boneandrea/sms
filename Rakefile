# frozen_string_literal: true

require 'yard'
require 'yard/rake/yardoc_task'

# task :default => :hello
task default: :hello

desc 'hello'
task :hello do
  puts 'Hello Rake!!'
end

YARD::Rake::YardocTask.new do |t|
  t.files = %w[
    *.rb
  ]
  t.options = []
  t.options = %w[--debug --verbose] if $trace
end

require 'rubocop/rake_task'
RuboCop::RakeTask.new
