# All right reserved.
#   (c) 2013 Paul Asmuth <paul@paulasmuth.com>

module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module HeidelpayHco
        class Helper < ActiveMerchant::Billing::Integrations::Helper

          STATIC_FIELDS = {
            "ACCOUNT.HOLDER"        => "",
            "ACCOUNT.NUMBER"        => "",
            "ACCOUNT.BRAND"         => "",
            "ACCOUNT.EXPIRY_MONTH"  => "",
            "ACCOUNT.EXPIRY_YEAR"   => "",
            "ACCOUNT.VERIFICATION"  => "",
            "PRESENTATION.CURRENCY" => "EUR",
            "PAYMENT.CODE"          => "CC.DB"
          }

          mapping :account,     "USER.LOGIN"
          mapping :credential2, "USER.PWD"
          mapping :credential3, "SECURITY.SENDER"
          mapping :credential4, "TRANSACTION.CHANNEL"

          def get_redirect_url(target_url)
            @fields.merge!(STATIC_FIELDS)
            @fields.merge!("FRONTEND.RESPONSE_URL" => target_url)
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

          private

          def serialize_params(hash)
            hash.map{ |key, value| "#{key}=#{value}" }.join("&")
          end

        end
      end
    end
  end
end
