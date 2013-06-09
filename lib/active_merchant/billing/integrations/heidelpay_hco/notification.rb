# All right reserved.
#   (c) 2013 Paul Asmuth <paul@paulasmuth.com>

module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module HeidelpayHco
        class Notification < ActiveMerchant::Billing::Integrations::Notification

          def complete?
            success?
          end

          def success?
            status == "Completed"
          end

          def status
            if params["PROCESSING.STATUS.CODE"].to_i == 90
              "Completed"
            else
              "Failed"
            end
          end

          def received_at
            DateTime.parse(params["CLEARING.DATE"])
          end

          def amount
            params["CLEARING_AMOUNT"]
          end

          def transaction_id
            params["IDENTIFICATION.TRANSACTIONID"]
          end

          def acknowledge
            true
          end

        end
      end
    end
  end
end
