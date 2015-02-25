#!/usr/bin/env ruby
# encoding: utf-8

require "bunny"
require_relative '../config'

conn = Bunny.new p RABBIT_URL
conn.start

ch   = conn.create_channel
q    = ch.queue("task_queue", :durable => true)

msg  = ARGV.empty? ? "Hello World!" : ARGV.join(" ")

q.publish(msg, :persistent => true)
puts " [x] Sent #{msg}"

sleep 1.0
conn.close

