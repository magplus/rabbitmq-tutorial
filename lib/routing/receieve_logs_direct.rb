#!/usr/bin/env ruby
# encoding: utf-8

require "bunny"

if ARGV.empty?
  abort "Usage: #{$0} [info] [warning] [error]"
end

conn = Bunny.new ENV['RABBIT_URL']
conn.start

ch  = conn.create_channel
x   = ch.direct("direct_logs", :durable => true)
q   = ch.queue(ENV["QUEUE_NAME"], :exclusive => false, :durable => true)

ARGV.each do |severity|
  q.bind(x, :routing_key => severity)
end

puts " [*] Waiting for logs. To exit press CTRL+C"

begin
  q.subscribe(:block => true) do |delivery_info, properties, body|
    puts " [x] #{delivery_info.routing_key}:#{body} (received at #{Time.now.to_i})"
  end
rescue Interrupt => _
  ch.close
  conn.close
end
