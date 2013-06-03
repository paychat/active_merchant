# All right reserved.
#   (c) 2013 Paul Asmuth <paul@paulasmuth.com>

module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module HeidelpayHco
        class Helper < ActiveMerchant::Billing::Integrations::Helper
          include PostsData

          STATIC_FIELDS = {
            "ACCOUNT.HOLDER"             => "",
            "ACCOUNT.NUMBER"             => "",
            "ACCOUNT.BRAND"              => "",
            "ACCOUNT.EXPIRY_MONTH"       => "",
            "ACCOUNT.EXPIRY_YEAR"        => "",
            "ACCOUNT.VERIFICATION"       => "",
            "PRESENTATION.CURRENCY"      => "EUR",
            "PAYMENT.CODE"               => "CC.DB",
            "FRONTEND.MODE"              => "DEFAULT",
            "FRONTEND.ENABLED"           => "true",
            "FRONTEND.POPUP"             => "false",
            "FRONTEND.REDIRECT_TIME"     => "0",
            "FRONTEND.LANGUAGE_SELECTOR" => "true",
            "REQUEST.VERSION"            => "1.0"
          }

          mapping :account,     "USER.LOGIN"
          mapping :credential2, "USER.PWD"
          mapping :credential3, "SECURITY.SENDER"
          mapping :credential4, "TRANSACTION.CHANNEL"
          mapping :amount,      "PRESENTATION.AMOUNT"
          mapping :order,       "IDENTIFICATION.TRANSACTIONID"

          mapping :billing_address,
             :first_name => "NAME.GIVEN",
             :last_name  =>  "NAME.FAMILY",
             :city       => 'ADDRESS.CITY',
             :address    => 'ADDRESS.STREET',
             :zip        => 'ADDRESS.ZIP',
             :country    => 'ADDRESS.COUNTRY',
             :email      => 'CONTACT.EMAIL'

          def get_redirect_url(response_url)
            # merge static fields + response_url
            @fields.merge!(STATIC_FIELDS)
            @fields.merge!("FRONTEND.RESPONSE_URL" => response_url)

            # convert amount to the right representation (%.2f)
            amount = @fields["PRESENTATION.AMOUNT"].to_i / 100
            @fields["PRESENTATION.AMOUNT"] = "%.2f" % amount

            # add the current locale
            @fields["FRONTEND.LANGUAGE"] = I18n.locale.upcase

            # add the transaction mode (live vs. test)
            txmode = test? ? "INTEGRATOR_TEST" : "LIVE"
            @fields["TRANSACTION.MODE"] = txmode

            # post to heidelpay gateway to get the redirect url
            fields = serialize_params(@fields)
            resp = ssl_post(gateway_url, fields)
            return nil unless resp

            # parse the response parameters and return the response url
            resp_fields = parse_params(resp)
            URI::decode(resp_fields["FRONTEND.REDIRECT_URL"])
          end

          def gateway_url
            if test?
              "https://test-heidelpay.hpcgw.net/sgw/gtw"
            else
              "https://heidelpay.hpcgw.net/sgw/gtw"
            end
          end

          # set the usage / verwendungszweck
          def usage=(str)
            @fields["PRESENTATION.USAGE"] = str
          end

          private

          def serialize_params(hash)
            hash.map{ |key, value| "#{key}=#{value}" }.join("&")
          end

          def parse_params(string)
            Hash[string.split("&").compact.map{ |tuple| tuple.split("=") }]
          end

        end
      end
    end
  end
end
