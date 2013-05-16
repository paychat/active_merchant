require 'uri'
require 'cgi'

module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module HeidelPay
        class Helper < ActiveMerchant::Billing::Integrations::Helper
          include PostsData

          #debug
          self.ssl_strict = false

          mapping :account, 'USER.LOGIN'
          mapping :credential2, 'USER.PWD'
          mapping :credential3, 'SECURITY.SENDER'
          mapping :credential4, 'TRANSACTION.CHANNEL'

          mapping :amount, 'PRESENTATION.AMOUNT'
          mapping :currency, 'PRESENTATION.CURRENCY'

          mapping :order, 'IDENTIFICATION.TRANSACTIONID'

          mapping :locale, 'FRONTEND.LANGUAGE'

          mapping :notify_url, ''
          mapping :return_url, 'FRONTEND.RESPONSE_URL'
          mapping :cancel_return_url, ''
          mapping :description, 'PRESENTATION.USAGE'

          def initialize(order, account, options = {})
            super
            add_field 'REQUEST.VERSION', '1.0'
            add_field 'TRANSACTION.MODE', (test? ? 'INTEGRATOR_TEST' : 'LIVE')
            add_field 'FRONTEND.ENABLED', 'true'
            add_field 'FRONTEND.POPUP', 'false'
            add_field 'FRONTEND.MODE', 'DEFAULT'
          end

          def form_fields
            @fields['FRONTEND.LANGUAGE'].upcase!

            request = URI.encode_www_form(@fields)

            response = CGI.parse ssl_post(ActiveMerchant::Billing::Integrations::HeidelPay.service_url, request)

            result = response['POST.VALIDATION'].first
            redirect = response['FRONTEND.REDIRECT_URL'].first
          end
        end
      end
    end
  end
end
