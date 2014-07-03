#!/usr/bin/env ruby
# encoding: utf-8

require "bunny"

# conn = Bunny.new(:automatically_recover => true)
# conn = Bunny.new("amqp://pond:1234@172.18.1.187:5672")
conn = Bunny.new("amqp://admin:admin@localhost:5672")
conn.start

ch  = conn.create_channel
ch.prefetch(1)
x   = ch.fanout("NotificationExchange", :durable => false)
q   = ch.queue("NotificationQueue", :durable => true, :auto_delete => false)

q.bind(x)


begin
  puts " [*] Waiting for logs. To exit press CTRL+C"
  q.subscribe(:ack => true, :block => true) do |delivery_info, properties, body|
    puts " Got message '#{body}', redelivered?: #{delivery_info.redelivered?}, ack-ed"
    sleep 3
    ch.ack(delivery_info.delivery_tag, true)
  end
rescue Interrupt => _
  ch.close
  conn.close

  exit(0)
end