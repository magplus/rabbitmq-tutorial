#!/usr/bin/env ruby
# encoding: utf-8

require "bunny"

conn = Bunny.new ENV['RABBIT_URL']
conn.start

ch       = conn.create_channel
x        = ch.direct("direct_logs", :durable => true)
severity = ARGV.shift || "info"
msg      = ARGV.empty? ? "Hello World!" : ARGV.join(" ")

100.times do
  x.publish("msg #{Time.now.to_i}", :routing_key => severity, :persistent => true)
end
puts " [x] Sent '#{msg}'"

conn.close

