# All right reserved.
#   (c) 2013 Paul Asmuth <paul@paulasmuth.com>

module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module HeidelpayHco
        autoload :Helper,       'active_merchant/billing/integrations/heidelpay_hco/helper.rb'
        autoload :Notification, 'active_merchant/billing/integrations/heidelpay_hco/notification.rb'

        def self.notification(post, options = {})
          Notification.new(post)
        end

        def self.return(query_string, options = {})
          ActiveMerchant::Billing::Integrations::Return.new(query_string)
        end
      end
    end
  end
end
