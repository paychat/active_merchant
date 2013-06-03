# All right reserved.
#   (c) 2013 Paul Asmuth <paul@paulasmuth.com>
#
# Usage
# =====
#
# > Step1:
#  In the "checkout" action, call this, it will return a url on heidelpays server:
#
#     helper = HeidelpayHco::Helper.new(
#       '42',                                                          # order no.
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
#     @helper.usage = "Verwendungszweck"
#
#     # this returns a url
#     helper.get_redirect_uri("/my_response_url")
#
# > Step 2:
#  Redirect the user to the url that was returned in step 1 (or display an iframe).
#
# > Step 3:
#  Heidelpay will redirect the user back to the url you provided ("/my_response_url" in
#  the example above). The action that responds to this response url must call this:
#
#     ... notification example ...
#
#
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
