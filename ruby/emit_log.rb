#!/usr/bin/env ruby
# encoding: utf-8

require "bunny"

# conn = Bunny.new(:automatically_recover => true)
# conn = Bunny.new("amqp://pond:1234@172.18.1.187:5672")
conn = Bunny.new("amqp://admin:admin@localhost:5672")
conn.start

ch   = conn.create_channel
x    = ch.fanout("logs")

msg  = ARGV.empty? ? "Hello World!" : ARGV.join(" ")

x.publish(msg)
puts " [x] Sent #{msg}"

conn.close