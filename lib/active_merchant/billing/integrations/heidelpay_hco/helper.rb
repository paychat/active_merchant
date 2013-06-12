# All right reserved.
#   (c) 2013 Paul Asmuth <paul@paulasmuth.com>

module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module HeidelpayHco
        class Helper < ActiveMerchant::Billing::Integrations::Helper
          include PostsData

          mapping :account,     'USER.LOGIN'
          mapping :credential2, 'USER.PWD'
          mapping :credential3, 'SECURITY.SENDER'
          mapping :credential4, 'TRANSACTION.CHANNEL'

          mapping :amount, 'PRESENTATION.AMOUNT'
          mapping :currency, 'PRESENTATION.CURRENCY'
          mapping :order, 'IDENTIFICATION.TRANSACTIONID'

          mapping :description, 'PRESENTATION.USAGE'
          mapping :language, 'FRONTEND.LANGUAGE'
          mapping :return_url, 'FRONTEND.RESPONSE_URL'

          mapping :billing_address,
            :first_name => 'NAME.GIVEN',
            :last_name => 'NAME.FAMILY',
            :city => 'ADDRESS.CITY',
            :address => 'ADDRESS.STREET',
            :zip => 'ADDRESS.ZIP',
            :country => 'ADDRESS.COUNTRY',
            :email => 'CONTACT.EMAIL'

          def initialize(order, account, options = {})
            super
            add_field 'REQUEST.VERSION', '1.0'
            add_field 'TRANSACTION.MODE', (test? ? 'INTEGRATOR_TEST' : 'LIVE')
            add_field 'FRONTEND.LANGUAGE_SELECTOR', 'true'
            add_field 'FRONTEND.ENABLED', 'true'
            add_field 'FRONTEND.POPUP', 'false'
            add_field 'FRONTEND.MODE', 'DEFAULT'
            add_field 'FRONTEND.LANGUAGE', I18n.locale.upcase

            #add_field 'ACCOUNT.HOLDER', ''
            #add_field 'ACCOUNT.NUMBER', ''
            #add_field 'ACCOUNT.BRAND', ''
            #add_field 'ACCOUNT.EXPIRY_MONTH', ''
            #add_field 'ACCOUNT.EXPIRY_YEAR', ''
            #add_field 'ACCOUNT.VERIFICATION', ''
            #add_field 'PAYMENT.CODE', 'CC.DB'
            #add_field 'FRONTEND.REDIRECT_TIME', '0'
          end

          def get_redirect_url(response_url)
            self.return_url = response_url

            # convert amount to the right representation (%.2f)
            @fields['PRESENTATION.AMOUNT'] = '%.2f' % @fields['PRESENTATION.AMOUNT']

            request = URI.encode_www_form form_fields
            response = CGI.parse ssl_post(ActiveMerchant::Billing::Integrations::HeidelpayHco.service_url, request)

            result = response['POST.VALIDATION'].try :first
            redirect = response['FRONTEND.REDIRECT_URL'].try :first

            raise "Invalid Request, Error Code: #{result}" if result != 'ACK'
            raise 'Invalid Request. Redirect isn\'t specified.' if redirect.blank?

            redirect
          end
        end
      end
    end
  end
end
