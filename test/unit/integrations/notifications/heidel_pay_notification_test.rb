require 'test_helper'

class HeidelPayNotificationTest < Test::Unit::TestCase
  include ActiveMerchant::Billing::Integrations

  def setup
    @heidel_pay = HeidelPay::Notification.new(http_raw_data)
  end

  def test_accessors
    assert @heidel_pay.complete?
    assert_equal "", @heidel_pay.status
    assert_equal "", @heidel_pay.transaction_id
    assert_equal "", @heidel_pay.item_id
    assert_equal "", @heidel_pay.gross
    assert_equal "", @heidel_pay.currency
    assert_equal "", @heidel_pay.received_at
    assert @heidel_pay.test?
  end

  def test_compositions
    assert_equal Money.new(3166, 'USD'), @heidel_pay.amount
  end

  # Replace with real successful acknowledgement code
  def test_acknowledgement

  end

  def test_send_acknowledgement
  end

  def test_respond_to_acknowledge
    assert @heidel_pay.respond_to?(:acknowledge)
  end

  private
  def http_raw_data
    ""
  end
end
