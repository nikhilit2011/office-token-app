class TokensChannel < ApplicationCable::Channel
  def subscribed
    stream_from "tokens_channel"
  end
end
