# All right reserved.
#   (c) 2013 Paul Asmuth <paul@paulasmuth.com>
#
# Usage
# =====
#
# > Step1:
#  In the "checkout" action, call this, it will return a url on heidelpays server:
#
#     @helper = HeidelpayHco::Helper.new(
#       '42',                                                          # transaction id (chosen by you).
#       '31ha07bc810c91f086431f7471d042d6',                            # heidelpay login
#       :amount                 => 500,                                # amount in cents
#       :credential2            => 'password',                         # heidelpay password
#       :credential3            => '31HA07BC810C91F08643A5D477BDD7C0', # heidelpay sender
#       :credential4            => '31HA07BC810C91F086433734258F6628) # heidelpay channel
#
#     # set the customer data
#     @helper.billing_address(
#       :first_name => "Hanz",
#       :last_name  => "Mustermann",
#       :address    => "Musterstrasse 1",
#       :zip        => "12345",
#       :city       => "Demo City",
#       :country    => "DE",
#       :email      => "test@test.de")
#
#     # set the usage / payment title
#     @helper.description = "Verwendungszweck"
#
#     # set the amount (23.50€)
#     @helper.amount = 2350
#     @helper.currency = 'EUR'
#
#     # this returns a url
#     helper.get_redirect_uri("/my_response_url")
#
# > Step 2:
#  Redirect the user to the url that was returned in step 1 (or display an iframe).
#
# > Step 3:
#  Heidelpay will redirect the user back to the url you provided ("/my_response_url" in
#  the example above). The action that responds to this response url must call this code
#  and respond with another url (to which heidelpay will redirect the user)
#
#     notify = ActiveMerchant::Billing::Integrations::HeidelpayHco::Notification.new(params)
#
#     if notify.success?
#       notify.amount # => "23.50"
#       notify.transaction_id # => "42" (the id you passed above)
#       notify.received_at # => time at which this tx was processed
#       # process order here
#     end
#
#     render :text => "http://my-target-url.com/"
#
module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module HeidelpayHco
        autoload :Helper,       'active_merchant/billing/integrations/heidelpay_hco/helper.rb'
        autoload :Notification, 'active_merchant/billing/integrations/heidelpay_hco/notification.rb'

        mattr_accessor :test_url
        self.test_url = 'https://test-heidelpay.hpcgw.net/sgw/gtw'

        mattr_accessor :production_url
        self.production_url = 'https://heidelpay.hpcgw.net/sgw/gtw'

        def self.service_url
          mode = ActiveMerchant::Billing::Base.integration_mode
          case mode
            when :production
              self.production_url
            when :test
              self.test_url
            else
              raise StandardError, "Integration mode set to an invalid value: #{mode}"
          end
        end

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
