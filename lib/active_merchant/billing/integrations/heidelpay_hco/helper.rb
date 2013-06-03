# All right reserved.
#   (c) 2013 Paul Asmuth <paul@paulasmuth.com>

module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module HeidelpayHco
        class Helper < ActiveMerchant::Billing::Integrations::Helper

          mapping :account,     "USER.LOGIN"
          mapping :credential2, "USER.PWD"
          mapping :credential3, "SECURITY.SENDER"
          mapping :credential4, "TRANSACTION.CHANNEL"

          def form_fields
            { :redirect_url => get_redirect_url }
          end

          private

          def get_redirect_url
            fields = serialize_params(@fields)
            response = ssl_post(gateway_url, fields)
          end

          def gateway_url
            if test?
              "https://test-heidelpay.hpcgw.net/sgw/gtw"
            else
              "https://heidelpay.hpcgw.net/sgw/gtw"
            end
          end

          def serialize_params(hash)
            hash.map{ |key, value| "#{key}=#{value}" }.join("&")
          end

        end
      end
    end
  end
end
