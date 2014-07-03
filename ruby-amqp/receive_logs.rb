#!/usr/bin/env ruby
# encoding: utf-8

require "amqp"

EventMachine.run do 
  # AMQP.start(:host => "172.18.1.187", :user => "pond", :pass => "1234") do |connection|
  AMQP.start(:host => "172.18.1.187", :user => "pond", :pass => "1234") do |connection|
    channel  = AMQP::Channel.new(connection)
    exchange = channel.fanout("NotificationExchange", :durable => true)
    queue    = channel.queue("NotificationQueue", :durable => true, :auto_delete => false)

    queue.bind(exchange)

    Signal.trap("INT") do
      connection.close do
        EM.stop { exit }
      end
    end

    puts " [*] Waiting for Notification. To exit press CTRL+C"
    
    queue.subscribe do |body|

      puts " [x] #{body}"
      sleep 3.0
      connection.close {
        EventMachine.stop { exit }
      }
    end
  end
end