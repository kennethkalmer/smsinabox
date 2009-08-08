module Smsinabox

  class Message

    attr_accessor :recipient
    attr_accessor :body

    def initialize( options = {} )
      @recipient = options.delete(:recipient)
      @body      = options.delete(:body)
    end

    def valid?
      !( @recipient.nil? || @body.nil? )
    end

    def body
      @body.gsub( /\n/, '|' )
    end
  end
end
