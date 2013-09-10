# -*- encoding : utf-8 -*-
# Supported options: :resque, :sidekiq, :delayed_job, :queue_classic
Devise::Async.backend = :delayed_job

module Devise
  module Models
    module Confirmable
      handle_asynchronously :send_confirmation_instructions
    end

    module Recoverable
      handle_asynchronously :send_reset_password_instructions
    end

    module Lockable
      handle_asynchronously :send_unlock_instructions
    end
  end
end
