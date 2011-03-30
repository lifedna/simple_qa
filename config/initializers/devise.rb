Devise.setup do |config|
  config.mailer_sender = "noreply@simple_qa.com"
  require 'devise/orm/mongoid'
  config.stretches = 10
  config.pepper = "552d0d55529ae12b7287927698cda46c7748ba82d6d0f9a8e0d7e4f203c575b58c5370003d0562202d8f629345e7e1ab5c640d200a496b98a20beb25831c413f"
end
