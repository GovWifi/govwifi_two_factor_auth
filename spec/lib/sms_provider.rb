require "ostruct"

class SmsProvider
  Message = Class.new(OpenStruct)

  class_attribute :messages
  self.messages = []

  def self.send_message(opts = {})
    messages << Message.new(opts)
  end

  def self.last_message
    messages.last
  end
end
